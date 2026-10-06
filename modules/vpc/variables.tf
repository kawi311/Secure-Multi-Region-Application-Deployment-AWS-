variable "name" {
    description = "Prefix name for all VPC resources"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type = string
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets, one per AZ"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets, one per AZ"
    type = list(string)
}

variable "azs" {
    description = "List of availability zones to use for the subnets"
    type = list(string)
}

variable "admin_cidr" {
    description = "CIDR block for admin access (SSH). Should be restricted to your IP or CIDR. Empty = disabled"
    type = string
    default = ""
}

variable "block_cidr" {
    description = "Optional CIDR to explicitly block at NACL level (empty for none)"
    type = string
    default = ""
}
