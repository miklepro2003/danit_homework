variable "aws_region" {
  description = "Регион AWS"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR для VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR для публичной подсети"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Тип EC2-инстанса"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Имя существующей SSH key pair в AWS"
  default     = "my-key"
}