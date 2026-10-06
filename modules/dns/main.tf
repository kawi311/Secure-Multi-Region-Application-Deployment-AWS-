# --- Health Checks for Failover ---
# Tạo một health check tường minh cho ALB chính (primary)
resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/health" # Đường dẫn health check của ALB Target Group
  failure_threshold = 3         # Chuyển sang Unhealthy sau 3 lần thất bại

  tags = {
    Name = "Health check for Primary ALB - ${var.record_name}"
  }
}

# Tạo một health check tường minh cho ALB phụ (secondary)
resource "aws_route53_health_check" "secondary" {
  fqdn              = var.secondary_alb_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = 3

  tags = {
    Name = "Health check for Secondary ALB - ${var.record_name}"
  }
}

# Primary DNS Record (Type A - Alias to Primary ALB)
resource "aws_route53_record" "primary_alb_record" {
  zone_id = var.hosted_zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.primary_alb_dns_name
    zone_id                = var.primary_alb_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary.id       # Liên kết với health check tường minh
  set_identifier  = "${var.record_name}-primary-alb-failover" # Unique identifier for failover records
}

# Secondary DNS Record (Type A - Alias to Secondary ALB)
resource "aws_route53_record" "secondary_alb_record" {
  zone_id = var.hosted_zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.secondary_alb_dns_name
    zone_id                = var.secondary_alb_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }

  health_check_id = aws_route53_health_check.secondary.id       # Liên kết với health check tường minh
  set_identifier  = "${var.record_name}-secondary-alb-failover" # Unique identifier for failover records
}
