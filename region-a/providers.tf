provider "aws" {
  region = "ap-southeast-1" # Provider mặc định cho region-a
}

# Provider cho region đích (us-east-1) để sao chép snapshot RDS hoặc các tác vụ liên region khác
provider "aws" {
  alias  = "replication"
  region = "us-east-1"
}
