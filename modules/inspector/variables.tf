variable "scan_types" {
  description = "Danh sách các loại tài nguyên cần quét. Giá trị hợp lệ: EC2, ECR."
  type        = list(string)
  default     = ["EC2"]
}
