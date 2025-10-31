provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "swathi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Swathi-VPC"
  }
}

resource "aws_subnet" "swathi_public_subnet" {
  vpc_id                  = aws_vpc.swathi_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Swathi-public-subnet"
  }
}

resource "aws_internet_gateway" "swathi_gw" {
  vpc_id = aws_vpc.swathi_vpc.id
  tags = {
    Name = "Swathi-internet-gateway"
  }
}

resource "aws_route_table" "swathi_public_rt" {
  vpc_id = aws_vpc.swathi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.swathi_gw.id
  }
  tags = {
    Name = "Swathi-route-table"
  }
}

resource "aws_route_table_association" "swathi_public_assoc" {
  subnet_id      = aws_subnet.swathi_public_subnet.id
  route_table_id = aws_route_table.swathi_public_rt.id
}

resource "aws_s3_bucket" "swathi_terraform_bucket" {
  bucket        = "swathi-demo-bucket-assignment3"
  force_destroy = true
  tags = {
    Name        = "Swathi-S3-bucket"
    Environment = "Dev"
  }
}
