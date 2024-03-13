# Creating Elastic ip for the NAT Gateway 1 

resource "aws_eip" "NAT-EIP-1" {
  tags = {
    Name = "NAT-EIP-1"
  }
}

resource "aws_eip" "NAT-EIP-2" {
  tags = {
    Name = "NAT-EIP-2"
  }
}


# Creating Two NAT Gatewayes
resource "aws_nat_gateway" "NAT-1" {
  allocation_id = aws_eip.NAT-EIP-1.id
  subnet_id     = var.PUB-SUB-1-ID

  tags = {
    Name = "${var.PROJECT_NAME}NAT-1"
  }

  depends_on = [var.IGW-ID]
}

resource "aws_nat_gateway" "NAT-2" {
  allocation_id = aws_eip.NAT-EIP-2.id
  subnet_id     = var.PUB-SUB-2-ID

  tags = {
    Name = "${var.PROJECT_NAME}NAT-2"
  }

  depends_on = [var.IGW-ID]
}

# Creating 2 Private RT
resource "aws_route_table" "Private-RT-1" {
  vpc_id = var.VPC-ID

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-1.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-PRIV-RT-1"
  }
}

resource "aws_route_table" "Private-RT-2" {
  vpc_id = var.VPC-ID

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-2.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-PRIV-RT-2"
  }
}


# Association Of The PRIV Subnets
resource "aws_route_table_association" "Attach-PRIV-SUB-1" {
  route_table_id = aws_route_table.Private-RT-1.id
  subnet_id      = var.PRIV-SUB-1-ID
}
resource "aws_route_table_association" "Attach-PRIV-SUB-2" {
  route_table_id = aws_route_table.Private-RT-2.id
  subnet_id      = var.PRIV-SUB-2-ID
}
