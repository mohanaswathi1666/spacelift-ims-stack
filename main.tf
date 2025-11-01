provider "aws" {
  region = "ap-south-1"
}

# Get existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-014ef1f28181ec49d"
}

# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Example-Subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "datasource-Terraform-internet-gateway"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow RDS access"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.example_subnet.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS instance
resource "aws_db_instance" "example_rds" {
  identifier              = "example-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "exampledb"
  username                = "admin"
  password                = "YourSecurePassword123!" # Use Spacelift context or variable in production
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name = "Example-RDS"
  }
}
