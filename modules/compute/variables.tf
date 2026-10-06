variable "name" {
  type        = string
  description = "Name prefix for compute resources"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs the ASG will use"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to attach to instances"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami" {
  type        = string
  description = "AMI id to use for instances"
}

variable "os" {
  type        = string
  description = "Operating system family: 'linux' or 'windows' (controls AMI lookup)"
  default     = "linux"
}

variable "key_name" {
  type        = string
  description = "Optional key pair name for SSH access"
  default     = ""
}

variable "user_data" {
  type        = string
  description = "Optional user data (cloud-init)"
  default     = ""
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "create_iam_instance_profile" {
  type    = bool
  default = true
}

variable "iam_instance_profile_name" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "user_data_base64" {
  type        = string
  description = "Optional user data (cloud-init) encoded in base64"
  default     = null
}
