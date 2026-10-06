variable "name" { type = string }

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" { type = string }

variable "ami" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = ""
}

variable "user_data" {
  type    = string
  default = ""
}

variable "user_data_base64" {
  type        = string
  description = "User data to provide when launching the instance, must be base64-encoded"
  default     = null
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

variable "iam_instance_profile_arn" {
  description = "ARN of an existing IAM instance profile to associate with the instances. If empty, a new one will be created."
  type        = string
  default     = ""
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to create. Only used if create_iam_instance_profile is true and iam_instance_profile_arn is empty."
  type        = string
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "os" {
  type        = string
  description = "Operating system family: 'linux' or 'windows' (controls AMI lookup)"
  default     = "linux"
}
