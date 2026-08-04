variable "vpc_id" {
    type = string
}

variable "list_of_open_ports" {
    type = list(string)          # для корректной работы toset(...) в main.tf
}

variable "subnet_id" {
    type = string
}