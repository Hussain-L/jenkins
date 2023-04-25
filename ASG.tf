resource "aws_autoscaling_group" "terraform-Jenkins-ASG" {
  name                      = "terraform-Jenkins-ASG"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 100
  health_check_type         = "EC2"
  desired_capacity          = 2
  target_group_arns         = module.alb.target_group_arns

  launch_template {
    id      = aws_launch_template.terraform-Jenkins-lt.id
    version = aws_launch_template.terraform-Jenkins-lt.latest_version
  }
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]

  tag {
    key                 = "Name"
    value               = "terraform-Jenkins-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "terraform-web-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.terraform-Jenkins-ASG.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "terraform-web-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.terraform-Jenkins-ASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "terraform-web-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.terraform-Jenkins-ASG.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "terraform-web-scale_down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.terraform-Jenkins-ASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}