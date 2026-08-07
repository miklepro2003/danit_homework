terraform {
  required_version = ">= 1.10.0"
  required_providers {

    aws = {    # провайдер для работы с amazon
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    local = {  # провайдер для работы с моим пк (для resource "local_file" "inventory" {...})
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}