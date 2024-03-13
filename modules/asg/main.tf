resource "aws_launch_template" "LTP" {
  name          = "${var.PROJECT_NAME}-LTP"
  image_id      = var.AMI
  instance_type = var.INSTANCE_TYPE
  user_data     = filebase64("../modules/asg/config.sh")

  vpc_security_group_ids = [var.WEB_SG_ID]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.PROJECT_NAME}-Web"
    }
  }
}


resource "aws_autoscaling_group" "ASG" {
  name                      = "${var.PROJECT_NAME}-ASG"
  desired_capacity          = var.DESIRED_CAPACITY
  min_size                  = var.MIN_SIZE
  max_size                  = var.MAX_SIZE
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.PUB-SUB-1-ID, var.PUB-SUB-2-ID]
  target_group_arns         = [var.TG-ARN]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.LTP.id
    version = aws_launch_template.LTP.latest_version
  }

  depends_on = [aws_launch_template.LTP]

  tag {
    key                 = "NAME"
    value               = "${var.PROJECT_NAME}-ASG"
    propagate_at_launch = true
  }
}

# Scale Up
resource "aws_autoscaling_policy" "ASG_Scale_Up" {
  name                   = "${var.PROJECT_NAME}-ASG-Scale-Up"
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "ASG-Scale_Up_Alarm" {
  alarm_name          = "${var.PROJECT_NAME}-ASG-Scale-Up-Alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.ASG_Scale_Up.arn]
}


# scale down 
resource "aws_autoscaling_policy" "ASG-Scale_Down" {
  name                   = "${var.PROJECT_NAME}-ASG-Scale-Down"
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


# scale down alarm
resource "aws_cloudwatch_metric_alarm" "ASG_Scale_Down_Alarm" {
  alarm_name          = "${var.PROJECT_NAME}-Asg-Scale-Down-Alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.ASG-Scale_Down.arn]
}
