variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-southeast-1"
}

provider "aws" {
  region = var.region
}
