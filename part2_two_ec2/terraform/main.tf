terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# --------------------------
# VPC, Subnet, IGW, and Route Table
# --------------------------
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "flask-express-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "flask-express-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --------------------------
# Security Groups
# --------------------------
resource "aws_security_group" "flask_sg" {
  name   = "flask-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "Allow HTTP 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "flask-sg" }
}

resource "aws_security_group" "express_sg" {
  name   = "express-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "Allow Express HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description     = "Allow Flask to Express"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.flask_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "express-sg" }
}

# --------------------------
# EC2 Instances (Ubuntu, t3.micro)
# --------------------------
resource "aws_instance" "flask" {
  ami                    = "ami-0522ab6e1ddcc7055" # Ubuntu 22.04 LTS (ap-south-1)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/user_data_flask.sh")
  associate_public_ip_address = true

  tags = { Name = "flask-instance" }
}

resource "aws_instance" "express" {
  ami                    = "ami-0522ab6e1ddcc7055"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.express_sg.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/user_data_express.sh")
  associate_public_ip_address = true

  tags = { Name = "express-instance" }
}
