output "PUB-SUB-1-ID" {
  value = aws_subnet.PUB-SUB-1.id
}

output "PUB-SUB-2-ID" {
  value = aws_subnet.PUB-SUB-2.id
}

output "PRIV-SUB-1-ID" {
  value = aws_subnet.PRIV-SUB-1.id
}

output "PRIV-SUB-2-ID" {
  value = aws_subnet.PRIV-SUB-2.id
}


output "IGW-ID" {
  value = aws_internet_gateway.IGW.id
}

output "VPC-ID" {
  value = aws_vpc.vpc.id
}
