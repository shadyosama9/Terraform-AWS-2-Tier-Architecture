output "ALB-SG-ID" {
  value = aws_security_group.ALB-SG.id
}

output "DB-SG-ID" {
  value = aws_security_group.DB-SG.id
}

output "WEB-SG-ID" {
  value = aws_security_group.WEB-SG.id
}
