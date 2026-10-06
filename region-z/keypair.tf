resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "region-z-key" # Terraform sẽ tạo key pair với tên này
  public_key = tls_private_key.this.public_key_openssh
}

# Lưu private key vào file trên máy tính của bạn
resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${path.module}/region-z-key.pem"
}
