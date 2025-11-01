provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-014ef1f28181ec49d"
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Example-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "datasource-Terraform-internet-gateway"
  }
}
