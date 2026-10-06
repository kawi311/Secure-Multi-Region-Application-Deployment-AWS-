output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of public subnet IDs (one per AZ in the same order as var.azs)"
  value       = [for az in var.azs : aws_subnet.public[az].id]
}

output "private_subnets" {
  description = "List of private subnet IDs (one per AZ in the same order as var.azs)"
  value       = [for az in var.azs : aws_subnet.private[az].id]
}

# Backwards-compatible single outputs (map to first/second AZ when present)
output "private_subnet1_id" {
  description = "Compat: first private subnet (AZ 0)"
  value       = length(var.azs) > 0 ? aws_subnet.private[var.azs[0]].id : ""
}

output "private_subnet2_id" {
  description = "Compat: second private subnet (AZ 1)"
  value       = length(var.azs) > 1 ? aws_subnet.private[var.azs[1]].id : ""
}

output "public_subnet_id" {
  description = "Compat: first public subnet"
  value       = length(var.azs) > 0 ? aws_subnet.public[var.azs[0]].id : ""
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs keyed by AZ"
  value       = { for az, nat in aws_nat_gateway.nat : az => nat.id }
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "A list of IDs of the private route tables."
  value       = values(aws_route_table.private)[*].id
}

output "name" {
  description = "The name prefix passed to the module"
  value       = var.name
}
