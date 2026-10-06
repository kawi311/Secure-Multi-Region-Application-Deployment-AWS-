provider "aws" {
  region = "us-east-1" # Đây là region mặc định cho các tài nguyên trong region-z
}

provider "aws" {
  alias  = "region-z"
  region = "us-east-1" # Alias này được sử dụng bởi aws_db_instance.read_replica
}
