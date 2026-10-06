output "asg_cpu_alarm_arn" {
  description = "The ARN of the ASG High CPU utilization alarm."
  value       = aws_cloudwatch_metric_alarm.asg_high_cpu.arn
}

output "tg_unhealthy_host_alarm_arn" {
  description = "The ARN of the Target Group Unhealthy Host Count alarm."
  value       = aws_cloudwatch_metric_alarm.tg_unhealthy_hosts.arn
}
