terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-danit-devops-mi"
    region = "eu-central-1"
    key    = "mi/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}