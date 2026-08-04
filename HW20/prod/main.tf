# ====== Префикс ======
locals {
  name_prefix = "mi" 
}

# ====== VPC ======
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${local.name_prefix}-main" }
}

# ====== Подсеть ======
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.public_a
  availability_zone = "${var.aws_region}a"
  tags = { Name = "${local.name_prefix}-public-a" }
}

# ====== Internet Gateway ======
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${local.name_prefix}-igw" }
}

 # ====== Route tables ======
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"                     # весь исходящий трафик
    gateway_id = aws_internet_gateway.main.id     # идёт через Internet Gateway
  }
  tags = { Name = "${local.name_prefix}-public-rt" }
}

# ====== Привязка подсетей к route tables ======
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ====== Вызов модуля ======
module "web-server" {
  source = "../modules/web-server"  # путь до папки с кодом модуля
  vpc_id = aws_vpc.main.id             # передаем модулю сеть
  list_of_open_ports = [22, 80]        # передаем модулю порты
  subnet_id = aws_subnet.public_a.id
}