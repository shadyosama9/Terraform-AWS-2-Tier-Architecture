data "aws_acm_certificate" "Issued" {
  domain   = var.DOMAIN_NAME
  statuses = ["ISSUED"]
}


data "aws_route53_zone" "Terra-Zone" {
  name         = var.HOSTED_ZONE
  private_zone = false
}



resource "aws_route53_record" "Barista" {
  zone_id = data.aws_route53_zone.Terra-Zone.id
  name    = var.RECORD_NAME
  type    = "CNAME"
  ttl     = 60
  records = [var.ALB_DNS]
}
