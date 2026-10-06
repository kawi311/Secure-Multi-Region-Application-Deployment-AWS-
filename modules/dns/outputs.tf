output "primary_record_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the primary failover record."
  value       = aws_route53_record.primary_alb_record.fqdn
}

output "secondary_record_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the secondary failover record."
  value       = aws_route53_record.secondary_alb_record.fqdn
}
