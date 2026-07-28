terraform {                                    
  required_version = ">= 1.10.0"

  required_providers {                  
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {                            
    bucket = "backet-maikel-mini"
    region = "eu-central-1"
    key    = "network/terraform.tfstate" 
  }

}

#  ========== РЕГИОН ==========
provider "aws" {                         
  region = var.aws_region        
}