variable "name" {
  description = "Prefix/name for ALB resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC id where ALB will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB placement (recommended 2+ subnets across AZs)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID to associate with the ALB."
  type        = string
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS listener. If empty, only HTTP listener will be created."
  type        = string
  default     = ""
}

variable "web_acl_arn" {
  description = "Optional WAFv2 Web ACL ARN to associate with the ALB."
  type        = string
  default     = null
}

variable "associate_waf" {
  description = "If true, associate the WAF with the ALB. The web_acl_arn must be provided."
  type        = bool
  default     = false
}

variable "target_protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "HTTP"
}

variable "target_port" {
  description = "Port for target group"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for target group"
  type        = string
  default     = "/health"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "IP address type for the ALB (ipv4 or dualstack)"
  type        = string
  default     = "ipv4"
}
