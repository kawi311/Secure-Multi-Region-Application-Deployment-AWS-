module "region-a" {
  source               = "../modules/vpc"
  name                 = "region-a"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.4.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
  azs                  = ["ap-southeast-1a", "ap-southeast-1b"]
}

module "sg" {
  source   = "../modules/sg"
  name     = "region-a"
  vpc_id   = module.region-a.vpc_id
  app_port = 80
}

module "alb" {
  source         = "../modules/alb"
  name           = "region-a"
  vpc_id         = module.region-a.vpc_id
  public_subnets = module.region-a.public_subnets
  alb_sg_id      = module.sg.alb_sg_id
  web_acl_arn    = module.waf.web_acl_arn
  associate_waf  = var.associate_waf
}

# Optional WAF for ALB
module "waf" {
  source = "../modules/waf"
  name   = "region-a-waf"
  scope  = "REGIONAL"
}

# module "compute" {
#   source             = "../modules/compute"
#   name               = "region-a-compute"
#   private_subnet_ids = module.region-a.private_subnets
#   security_group_id  = module.sg.ec2_sg_id
#   ami                = var.ami
#   instance_type      = var.instance_type
#   key_name           = aws_key_pair.this.key_name
#   os                 = var.os
#   user_data_base64   = base64encode(file("${path.module}/../modules/compute/scripts/install_web.sh"))
#   tags = {
#     ManagedBy = "terraform"
#   }
# }

module "asg" {
  source                      = "../modules/asg"
  name                        = "region-a"
  private_subnet_ids          = module.region-a.private_subnets
  security_group_id           = module.sg.ec2_sg_id
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.key_name
  os                          = var.os
  target_group_arn            = module.alb.target_group_arn
  user_data_base64            = base64encode(file("${path.module}/../modules/compute/scripts/install_web.sh"))
  create_iam_instance_profile = false
  iam_instance_profile_arn    = aws_iam_instance_profile.ec2_profile.arn
  desired_capacity            = 1 # <-- Khôi phục lại

  depends_on = [
    module.region-a.private_route_table_ids
  ]
}

module "rds" {
  source                  = "../modules/rds"
  name                    = "region-a"
  vpc_id                  = module.region-a.vpc_id
  private_subnet_ids      = module.region-a.private_subnets
  app_security_group_id   = module.sg.ec2_sg_id
  db_username             = var.db_username
  multi_az                = var.db_multi_az
  backup_retention_period = 7 # Bật sao lưu tự động trong 7 ngày
  storage_encrypted       = var.db_storage_encrypted
}

data "aws_caller_identity" "current" {}

module "s3" {
  source                             = "../modules/s3"
  bucket_name                        = "quic1-intern-bucket-${data.aws_caller_identity.current.account_id}-a"
  enable_versioning                  = true # Bắt buộc cho replication
  enable_replication                 = true # Bật tính năng replication
  replication_destination_bucket_arn = "arn:aws:s3:::quic1-intern-bucket-${data.aws_caller_identity.current.account_id}-z"
  replication_iam_role_arn           = aws_iam_role.replication.arn
  tags = {
    ManagedBy = "terraform"
  }
}

module "sns" {
  source             = "../modules/sns"
  topic_name         = "region-a-alarms-topic"
  notification_email = var.admin_email
}

module "monitoring" {
  source = "../modules/monitoring"

  name_prefix              = "region-a"
  sns_topic_arn            = module.sns.sns_topic_arn
  asg_name                 = module.asg.asg_name
  target_group_arn_suffix  = split("/", module.alb.target_group_arn)[1]
  load_balancer_arn_suffix = split("/", module.alb.alb_arn)[1]

  tags = { ManagedBy = "terraform" }
}

# Kích hoạt AWS Inspector để quét bảo mật
module "inspector" {
  source = "../modules/inspector"
}

# --- RDS Automated Backup Replication ---
# Tài nguyên này chỉ thị cho AWS sao chép các bản backup tự động của RDS chính
# sang một region khác (us-east-1 trong trường hợp này).

resource "aws_db_instance_automated_backups_replication" "this" {
  provider               = aws.replication # Sửa lại để sử dụng đúng alias "replication" đã định nghĩa trong providers.tf
  source_db_instance_arn = module.rds.db_instance_arn
  kms_key_id             = var.replication_kms_key_arn # Sử dụng KMS key ở vùng phụ
}






