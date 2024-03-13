# Creating The VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.CIDR
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.PROJECT_NAME}-VPC"
  }
}


# Getting The AZS
data "aws_availability_zones" "AZS" {}

# Creating The IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.PROJECT_NAME}-IGW"
  }
}

#Creating Public Subnets
resource "aws_subnet" "PUB-SUB-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.PUB-SUB-1-CIDR
  availability_zone       = data.aws_availability_zones.AZS.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.PROJECT_NAME}-PUB-SUB1"
  }
}

resource "aws_subnet" "PUB-SUB-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.PUB-SUB-2-CIDR
  availability_zone       = data.aws_availability_zones.AZS.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.PROJECT_NAME}-PUB-SUB2"
  }
}

# Creating Public RT
resource "aws_route_table" "Public-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-PUB-RT"
  }
}

# Associating Subnets To Public RT
resource "aws_route_table_association" "Attach-PUB-SUB-1" {
  route_table_id = aws_route_table.Public-RT.id
  subnet_id      = aws_subnet.PUB-SUB-1.id
}

resource "aws_route_table_association" "Attach-PUB-SUB-2" {
  route_table_id = aws_route_table.Public-RT.id
  subnet_id      = aws_subnet.PUB-SUB-2.id
}

#Creating The Private Subnets
resource "aws_subnet" "PRIV-SUB-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PRIV-SUB-1-CIDR
  availability_zone = data.aws_availability_zones.AZS.names[0]

  tags = {
    Name = "${var.PROJECT_NAME}-PRIVE-SUB1"
  }
}

resource "aws_subnet" "PRIV-SUB-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PRIV-SUB-2-CIDR
  availability_zone = data.aws_availability_zones.AZS.names[1]

  tags = {
    Name = "${var.PROJECT_NAME}-PRIVE-SUB2"
  }
}
