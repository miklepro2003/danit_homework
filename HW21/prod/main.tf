# ====== VPC ======
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

# ====== Подсеть ======
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "${local.name_prefix}-public-a"
  }
}

# ====== Internet Gateway ======
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

# ====== Route Table ======
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

# ====== Ассоциация ======
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ====== Security Group ======
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "SSH + HTTP"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {  # правило на ВХОД для ansible
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {  # правило на ВХОД для nginx
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {   # правило на ВЫХОД для самой EC2
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ====== AMI ======
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ====== Два EC2-инстанса ======
resource "aws_instance" "ec2_1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = "${local.name_prefix}-ec2-1"
  }
}

resource "aws_instance" "ec2_2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = "${local.name_prefix}-ec2-2"
  }
}

# ====== IP для Inventory ======
resource "local_file" "inventory" {
  filename = "inventory.yaml"
  content = templatefile("inventory.tftpl", {
    host_1 = aws_instance.ec2_1.public_ip   # публичный IP первого созданного инстанса
    host_2 = aws_instance.ec2_2.public_ip   # публичный IP второго созданного инстанса
  })
}