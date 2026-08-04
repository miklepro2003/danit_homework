# ====== Переменные ======
variable "vpc_cidr" {  
  default = "10.0.0.0/16"   # диапазон адресов для новой VPC
}

variable "aws_region" {
  default = "eu-central-1"     
}

variable "subnet_cidrs" {
  default = {
    public_a  = "10.0.1.0/24"
  }
}
