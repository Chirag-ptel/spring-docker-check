output "vpc_id" {
  value = aws_vpc.my-vpc.id
 }

output "vpc_cidr_block" {
    value = aws_vpc.my-vpc.cidr_block
 }
 
output "vpc_arn" {
    value = aws_vpc.my-vpc.arn
 }

output "default_security_group_id" {
    value = aws_vpc.my-vpc.default_security_group_id
}

output "public_subnets" {
    value = aws_subnet.public.*.id
 }

output "private_subnets" {
    value = aws_subnet.private.*.id
 }

output "internet_gateway_id" {
    value = aws_internet_gateway.my-igw.id
 }


