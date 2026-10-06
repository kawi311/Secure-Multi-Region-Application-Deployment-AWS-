variable "name" {
  description = "Name prefix for SG resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the SGs"
  type        = string
}

variable "app_port" {
  description = "The port the application is listening on (e.g., 80)"
  type        = number
  default     = 80
}
