variable "region" {
  description = "The AWS region in which to create the VPC"
  default = "us-east-1"
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}