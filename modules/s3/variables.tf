
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "enable_versioning" {
  description = "Set to true to enable versioning on the bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "enable_replication" {
  description = "Set to true to enable cross-region replication."
  type        = bool
  default     = false
}

variable "replication_destination_bucket_arn" {
  description = "The ARN of the destination bucket for replication."
  type        = string
  default     = ""
}

variable "replication_iam_role_arn" {
  description = "The ARN of the IAM role to use for replication."
  type        = string
  default     = ""
}
