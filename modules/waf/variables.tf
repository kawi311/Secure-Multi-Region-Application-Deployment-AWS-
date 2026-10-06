variable "name" {
  description = "Name prefix for the WAF Web ACL"
  type        = string
  default     = "waf"
}

variable "scope" {
  description = "WAF scope - REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "managed_rule_groups" {
  description = "List of managed rule group identifiers to include (vendor_name = AWS). Order defines priority."
  type        = list(string)
  default     = ["AWSManagedRulesCommonRuleSet"]
}

variable "visibility_metrics_enabled" {
  description = "Whether to enable metric/visibility config"
  type        = bool
  default     = true
}

variable "visibility_sampled_requests_enabled" {
  description = "Whether to enable sampled requests in visibility config"
  type        = bool
  default     = true
}

variable "metric_name_prefix" {
  description = "Prefix used for WAF metrics"
  type        = string
  default     = "waf"
}
