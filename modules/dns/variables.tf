variable "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone where the records will be created."
  type        = string
}

variable "record_name" {
  description = "The name of the DNS record (e.g., 'www' for www.example.com, or '' for example.com for the root domain)."
  type        = string
  default     = ""
}

variable "primary_alb_dns_name" {
  description = "The DNS name of the primary Application Load Balancer."
  type        = string
}

variable "primary_alb_zone_id" {
  description = "The Route 53 Hosted Zone ID of the primary Application Load Balancer."
  type        = string
}

variable "secondary_alb_dns_name" {
  description = "The DNS name of the secondary Application Load Balancer."
  type        = string
}

variable "secondary_alb_zone_id" {
  description = "The Route 53 Hosted Zone ID of the secondary Application Load Balancer."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
