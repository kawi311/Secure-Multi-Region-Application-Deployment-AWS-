data "aws_caller_identity" "current" {}

resource "aws_inspector2_enabler" "this" {
  # Kích hoạt Inspector cho tài khoản hiện tại
  account_ids = [data.aws_caller_identity.current.account_id]

  # Chỉ định các loại tài nguyên cần quét 
  resource_types = var.scan_types
}
