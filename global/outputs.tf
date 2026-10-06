output "route53_name_servers" {
  description = "Các máy chủ tên (Name Servers) cho Hosted Zone vừa tạo. Bạn cần cập nhật các giá trị này tại nhà cung cấp tên miền của mình."
  value       = aws_route53_zone.this.name_servers
}
