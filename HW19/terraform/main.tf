
#  ========== СЕТЬ ==========
resource "aws_vpc" "main" {     
  cidr_block = var.vpc_cidr        

  tags = {
    Name = "${local.name_prefix}-main"  
  }
}

#  ========== ПОДСЕТИ ==========
resource "aws_subnet" "public_a" {                        
  vpc_id            = aws_vpc.main.id                     
  cidr_block        = var.subnet_cidrs.public_a        
  availability_zone = "${var.aws_region}a"               

tags = {
    Name = "${local.name_prefix}-public-a"  
  }
}

resource "aws_subnet" "public_b" {     
  vpc_id                 = aws_vpc.main.id
  cidr_block           = var.subnet_cidrs.public_b
  availability_zone = "${var.aws_region}b"

tags = {
    Name = "${local.name_prefix}-public-b"
  }
}

resource "aws_subnet" "private_a" {                   
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.private_a
  availability_zone = "${var.aws_region}a"

tags = {
    Name = "${local.name_prefix}-private-a"
  }
}

resource "aws_subnet" "private_b" {                  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs.private_b
  availability_zone = "${var.aws_region}b"

tags = {
    Name = "${local.name_prefix}-private-b"
  }
}


#  ========== INTERNET GATEWAY ==========
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id                           

tags = {
    Name = "${local.name_prefix}-igw"
  }
}

#  ========== ROUTE TABLE PUBLIC ==========
resource "aws_route_table" "public" {          
  vpc_id = aws_vpc.main.id                           

route {
    cidr_block   = "0.0.0.0/0"                                       
    gateway_id = aws_internet_gateway.main.id        
  }

tags = {
    Name = "${local.name_prefix}-public-rt"           
  }
}

#  ========== ROUTE TABLE PRIVATE ==========
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id                                    

route {
    cidr_block         = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id    
  }

tags = {
    Name = "${local.name_prefix}-private-rt"      
  }
}

#  ========== АССОЦИАЦИЯ ==========
resource "aws_route_table_association" "public_a" {   
  subnet_id         = aws_subnet.public_a.id                  
  route_table_id = aws_route_table.public.id              
}

resource "aws_route_table_association" "public_b" {   
  subnet_id      = aws_subnet.public_b.id                    
  route_table_id = aws_route_table.public.id             
}

resource "aws_route_table_association" "private_a" {   
  subnet_id      = aws_subnet.private_a.id                     
  route_table_id = aws_route_table.private.id               
}

resource "aws_route_table_association" "private_b" {   
  subnet_id      = aws_subnet.private_b.id                     
  route_table_id = aws_route_table.private.id               
}

#  ========== ELASTIC IP ==========
resource "aws_eip" "nat" {
  domain = "vpc"                  

tags = {
    Name = "${local.name_prefix}-nat"
  }
}

#  ========== NAT GATEWAY ==========
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id                  
  subnet_id     = aws_subnet.public_a.id    

tags = {
    Name = "${local.name_prefix}-nat"
  }

depends_on = [aws_internet_gateway.main]   
}

#  ========== SECURITY GROUP ==========
resource "aws_security_group" "main" {        
  name        = "${local.name_prefix}-sg"     
  description = "TF security group"          
  vpc_id      = aws_vpc.main.id               

tags = {
    Name = "${local.name_prefix}-sg"         
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {   
  security_group_id = aws_security_group.main.id       
  cidr_ipv4         = "0.0.0.0/0"                        
  from_port         = 22                                
  to_port           = 22                                
  ip_protocol       = "tcp"                             
}

resource "aws_vpc_security_group_egress_rule" "all" {   
  security_group_id = aws_security_group.main.id         
  cidr_ipv4         = "0.0.0.0/0"                       
  ip_protocol       = "-1"                             
}


#  ========== EC2 PUBLIC ==========
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ec2public" {
  ami                                = data.aws_ami.ubuntu.id
  instance_type                = "t3.micro"
  subnet_id                      = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.main.id] 
  key_name                      = "my-key"                        
  associate_public_ip_address = true

tags = {
    Name = "${local.name_prefix}-ec2public"
  }
}

#  ========== EC2 PRIVATE ==========

resource "aws_instance" "ec2private" {
  ami                                = data.aws_ami.ubuntu.id
  instance_type                = "t3.micro"
  subnet_id                      = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.main.id] 
  key_name                      = "my-key"                        
  associate_public_ip_address = false

tags = {
    Name = "${local.name_prefix}-ec2private"
  }
}
