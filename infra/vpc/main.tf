provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "petadd-s3-bucket-for-tfstate"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  
  tags = {
    Name = "my-igw"
  }
}

resource "aws_subnet" "public" {
  count = 3
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = aws_vpc.my-vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zones, count.index)
  
  tags = {
    Name = "my-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = 3
  cidr_block = "10.0.${count.index + 10}.0/24"
  vpc_id = aws_vpc.my-vpc.id
  map_public_ip_on_launch = false
  availability_zone = element(var.availability_zones, count.index)
  
  tags = {
    Name = "my-private-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

    tags = {
      Name = "my-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 3
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "my-nat-gw" {
  count = 3

  allocation_id = aws_eip.my-eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "my-nat-gw-${count.index}"
  }
}

resource "aws_eip" "my-eip" {
  count = 3

  vpc = true

  tags = {
    Name = "my-eip-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count = 3

  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gw[count.index].id
  }

  tags = {
    Name = "my-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = 3

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "public" {
  name_prefix = "my-public-sg-"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
 name_prefix = "my-private-sg-"
 vpc_id = aws_vpc.my-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = aws_subnet.public[*].cidr_block
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

