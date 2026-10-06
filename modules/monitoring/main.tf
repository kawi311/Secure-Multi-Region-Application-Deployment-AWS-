# Alarm for High CPU Utilization on the Auto Scaling Group
resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "${var.name_prefix}-asg-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period
  statistic           = "Average"
  threshold           = var.cpu_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "This metric alarms when the average CPU utilization of the ASG exceeds ${var.cpu_threshold}%."
  alarm_actions     = [var.sns_topic_arn]
  ok_actions        = [var.sns_topic_arn] # Optional: notify when the alarm state returns to OK

  tags = var.tags
}

# Alarm for Unhealthy Hosts in the Target Group
resource "aws_cloudwatch_metric_alarm" "tg_unhealthy_hosts" {
  alarm_name          = "${var.name_prefix}-tg-unhealthy-hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.unhealthy_host_evaluation_periods
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.unhealthy_host_period
  statistic           = "Maximum"
  threshold           = var.unhealthy_host_threshold

  dimensions = {
    TargetGroup  = var.target_group_arn_suffix
    LoadBalancer = var.load_balancer_arn_suffix
  }

  alarm_description = "This metric alarms when the number of unhealthy hosts in the target group is >= ${var.unhealthy_host_threshold}."
  alarm_actions     = [var.sns_topic_arn]
  ok_actions        = [var.sns_topic_arn] # Optional: notify when the alarm state returns to OK

  tags = var.tags
}
