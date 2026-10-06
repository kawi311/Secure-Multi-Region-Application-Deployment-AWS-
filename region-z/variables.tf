variable "associate_waf" {
  description = "If true, associate the WAF with the ALB."
  type        = bool
  default     = false # Bạn có thể đổi thành 'true' nếu muốn bật WAF cho region-z
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
  description = "Username for the master DB user in Region Z"
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

variable "admin_email" {
  description = "Admin email for receiving notifications."
  type        = string
}

variable "db_storage_encrypted" {
  description = "If true, encrypts the RDS database storage."
  type        = bool
  default     = false
}

variable "primary_rds_instance_arn" {
  description = "ARN of the primary RDS instance in Region A for replication."
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "kms_key_arn" {
  description = "ARN của KMS key ở region này (region-z) để mã hóa Read Replica."
  type        = string
  default     = "" # Sẽ được cung cấp qua terraform.tfvars
}
