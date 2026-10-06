output "db_password" {
  description = "Mật khẩu ngẫu nhiên của RDS"
  value       = random_password.db_password.result
  sensitive   = true
}

output "rds_sg_id" {
  description = "ID của security group RDS"
  value       = aws_security_group.rds_sg.id
}
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}
