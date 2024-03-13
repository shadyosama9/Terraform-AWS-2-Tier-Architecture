output "TG-ARN" {
  value = aws_lb_target_group.TG.arn
}

output "ALB-DNS" {
  value = aws_lb.ALB.dns_name
}

output "ALB-ZONE-ID" {
  value = aws_lb.ALB.zone_id
}
