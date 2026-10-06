# --- ALB (Load Balancer) Outputs ---
output "alb_dns_name" {
  description = "DNS name của Application Load Balancer để truy cập ứng dụng."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer."
  value       = module.alb.alb_zone_id
}

# --- RDS (Database) Outputs ---
output "rds_endpoint" {
  description = "Endpoint để kết nối tới RDS database."
  value       = module.rds.db_instance_endpoint
}

output "rds_db_password" {
  description = "Mật khẩu của RDS database (được tạo ngẫu nhiên)."
  value       = module.rds.db_password
  sensitive   = true
}

output "rds_instance_arn" {
  description = "ARN của RDS instance."
  value       = module.rds.db_instance_arn
}

# --- Key Pair Outputs ---
output "key_pair_name" {
  description = "Tên của Key Pair được tạo cho EC2 instances."
  value       = aws_key_pair.this.key_name
}

output "private_key_pem" {
  description = "Nội dung của private key để SSH vào EC2 instances. Hãy lưu lại cẩn thận."
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}

# --- VPC Outputs ---
output "vpc_id" {
  description = "ID của VPC."
  value       = module.region-a.vpc_id
}

output "public_subnet_ids" {
  description = "Danh sách ID của các public subnets."
  value       = module.region-a.public_subnets
}

output "private_subnet_ids" {
  description = "Danh sách ID của các private subnets."
  value       = module.region-a.private_subnets
}

# --- S3 Bucket Outputs ---
output "s3_bucket_name" {
  description = "Tên của S3 bucket."
  value       = module.s3.bucket_id
}
