output "instance_ids" {
  value = [for i in aws_instance.this : i.id]
}

output "private_ips" {
  value = [for i in aws_instance.this : i.private_ip]
}
