provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "spring-boot-tf-state-bucket"
    key    = "spring-boot-tf-state-bucket/deploy-docker/terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_ecr_repository" "ecr-repo" {
  name                 = "sample-dev-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = "bin/deploy-docker.sh quest-app ${aws_ecr_repository.quest_app.repository_url}:latest ap-south-1"
  }
  depends_on = ["aws_ecr_repository.ecr-repo"]
}