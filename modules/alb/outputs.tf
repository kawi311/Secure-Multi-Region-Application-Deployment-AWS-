output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.this.zone_id
}

output "alb_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "The ARN of the default target group."
  value       = aws_lb_target_group.tg.arn
}
