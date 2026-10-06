resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  scope       = var.scope
  description = "Managed WAF for ${var.name}"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.visibility_metrics_enabled
    metric_name                = "${var.metric_name_prefix}-${var.name}"
    sampled_requests_enabled   = var.visibility_sampled_requests_enabled
  }

  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = replace(rule.value, "/", "_")
      priority = index(var.managed_rule_groups, rule.value) * 10

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value
          vendor_name = "AWS"
        }
      }

      visibility_config {
        sampled_requests_enabled   = var.visibility_sampled_requests_enabled
        cloudwatch_metrics_enabled = var.visibility_metrics_enabled
        metric_name                = "${var.metric_name_prefix}-${var.name}-${replace(rule.value, "AWSManagedRules", "")}"
      }
    }
  }
}
