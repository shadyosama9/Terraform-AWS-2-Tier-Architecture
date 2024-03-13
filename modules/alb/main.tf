resource "aws_lb" "ALB" {
  name               = "${var.PROJECT_NAME}-ALB"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.ALB-SG]
  subnets         = [var.PUB-SUB-1-ID, var.PUB-SUB-2-ID]
}

resource "aws_lb_target_group" "TG" {
  name     = "${var.PROJECT_NAME}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  target_type = "instance"

  health_check {
    path = "/"
    port = "traffic-port"
  }
}


resource "aws_lb_listener" "Redirect" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.CER-ARN
  default_action {
    target_group_arn = aws_lb_target_group.TG.arn
    type             = "forward"
  }
}
