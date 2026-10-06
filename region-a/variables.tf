variable "admin_email" {
  description = "Admin email for receiving notifications."
  type        = string
}

variable "associate_waf" {
  description = "If true, associate the WAF with the ALB."
  type        = bool
  default     = true
}

variable "replication_kms_key_arn" {
  description = "ARN of the KMS key in the destination region to encrypt replicated snapshots."
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "os" {
  description = "Operating system for the EC2 instances. Can be 'linux' or 'windows'."
  type        = string
  default     = "linux"
}

variable "db_username" {
  description = "Username for the master DB user in Region A"
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "If true, deploy the RDS database in a Multi-AZ configuration."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for the RDS instance."
  type        = number
  default     = 0
}

variable "db_storage_encrypted" {
  description = "If true, encrypts the RDS database storage."
  type        = bool
  default     = false
}
