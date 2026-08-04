locals {
  name_prefix = "mi" 
}

# ====== SECURITY GROUP ======
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "TF security group"
  vpc_id      = var.vpc_id
  tags = { Name = "${local.name_prefix}-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" { # правило на ВХОД (ingress)
  for_each = toset(var.list_of_open_ports)
  
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"                    
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" { # правило на ВЫХОД (egress)

  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"                           
}

# ====== EC2-инстанс с Nginx ======
data "aws_ami" "ubuntu" {
  most_recent = true                    # брать самый свежий образ
  owners      = ["099720109477"]        # официальный аккаунт Canonical (Ubuntu)
 filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ec2public" {
  ami                          = data.aws_ami.ubuntu.id
  instance_type                = "t3.micro"
  subnet_id                    = var.subnet_id
  vpc_security_group_ids       = [aws_security_group.main.id]
  associate_public_ip_address  = true                               # публичный IP создаем
  user_data                   = file("${path.module}/userdata.sh")
  tags = { Name = "${local.name_prefix}-ec2public" }
}