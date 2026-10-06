variable "domain_name" {
  description = "Tên miền bạn sở hữu và muốn sử dụng (ví dụ: my-awesome-app.com)."
  type        = string
}

variable "record_name" {
  description = "Tên của bản ghi DNS bạn muốn tạo (ví dụ: 'app' cho app.yourdomain.com)."
  type        = string
  default     = "app"
}
