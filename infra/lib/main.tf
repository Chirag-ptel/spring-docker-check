data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-s3-bucket-for-tfstate"
    key    = "quest/dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

 output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
 }

 output "vpc_cidr_block" {
    value = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
 }

 output "default_security_group_id" {
    value = data.terraform_remote_state.vpc.outputs.default_security_group_id
 }

 output "public_subnets" {
    value = data.terraform_remote_state.vpc.outputs.public_subnets
 }

 output "private_subnets" {
    value = data.terraform_remote_state.vpc.outputs.private_subnets
 }

 output "security_group_id" {
  value = try(
    data.terraform_remote_state.vpc.outputs.security_groups.*.id[
      index(
        [
          for sg in data.terraform_remote_state.vpc.outputs.security_groups :
          sg.name_prefix == "my-private-sg-"
        ],
        0
      )
    ],
    null
  )
}
#hello
