variable "name_prefix" {
  description = "A prefix used for naming resources, e.g., 'region-a'."
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to send alarm notifications to."
  type        = string
}

variable "asg_name" {
  description = "The full name of the Auto Scaling Group to monitor."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "The suffix of the Target Group ARN (e.g., 'targetgroup/name/id')."
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "The suffix of the Load Balancer ARN (e.g., 'app/name/id')."
  type        = string
}

variable "cpu_threshold" {
  description = "The CPU utilization threshold for the alarm."
  type        = number
  default     = 75
}

variable "cpu_evaluation_periods" {
  description = "The number of periods over which to evaluate the CPU alarm."
  type        = number
  default     = 2
}

variable "cpu_period" {
  description = "The period in seconds over which to evaluate the CPU alarm."
  type        = number
  default     = 300
}

variable "unhealthy_host_threshold" {
  description = "The unhealthy host count threshold for the alarm."
  type        = number
  default     = 1
}

variable "unhealthy_host_evaluation_periods" {
  description = "The number of periods over which to evaluate the unhealthy host alarm."
  type        = number
  default     = 2
}

variable "unhealthy_host_period" {
  description = "The period in seconds over which to evaluate the unhealthy host alarm."
  type        = number
  default     = 60
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
