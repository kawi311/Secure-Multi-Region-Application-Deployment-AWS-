variable "topic_name" {
  description = "The name of the SNS topic to create."
  type        = string
}

variable "notification_email" {
  description = "The email address to subscribe to the SNS topic for notifications."
  type        = string
  # Consider adding a validation rule for email format if desired
  # validation {
  #   condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.notification_email))
  #   error_message = "The notification_email must be a valid email address."
  # }
}
