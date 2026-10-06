variable "environment" {
  description = "Deployment environment (eg. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name"
  type        = string
  default     = ""
}
