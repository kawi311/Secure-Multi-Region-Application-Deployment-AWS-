module "region-z" {
  source               = "../modules/vpc"
  name                 = "region-z"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.4.0/24"]
  private_subnet_cidrs = ["10.1.2.0/24", "10.1.3.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

module "sg" {
  source   = "../modules/sg"
  name     = "region-z"
  vpc_id   = module.region-z.vpc_id
  app_port = 80
}

module "alb" {
  source         = "../modules/alb"
  name           = "region-z"
  vpc_id         = module.region-z.vpc_id
  public_subnets = module.region-z.public_subnets
  alb_sg_id      = module.sg.alb_sg_id
  web_acl_arn    = module.waf.web_acl_arn
  associate_waf  = var.associate_waf
}

module "waf" {
  source = "../modules/waf"
  name   = "region-z-waf"
  scope  = "REGIONAL"
}

module "asg" {
  source                      = "../modules/asg"
  name                        = "region-z"
  private_subnet_ids          = module.region-z.private_subnets
  security_group_id           = module.sg.ec2_sg_id
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.key_name
  os                          = var.os
  target_group_arn            = module.alb.target_group_arn
  user_data_base64            = base64encode(file("${path.module}/../modules/compute/scripts/install_web.sh"))
  desired_capacity            = 1     # Phải nằm trong khoảng min_size và max_size
  create_iam_instance_profile = false # Tắt việc tự tạo IAM profile trong module
  iam_instance_profile_arn    = aws_iam_instance_profile.ec2_profile.arn

  depends_on = [
    module.region-z.private_route_table_ids
  ]
}

# module "compute" {
#   source             = "../modules/compute"
#   name               = "region-z-compute"
#   private_subnet_ids = module.region-z.private_subnets
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

module "rds" {
  source                  = "../modules/rds"
  name                    = "region-z"
  vpc_id                  = module.region-z.vpc_id
  private_subnet_ids      = module.region-z.private_subnets
  app_security_group_id   = module.sg.ec2_sg_id
  db_username             = var.db_username
  multi_az                = var.db_multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true # Bỏ qua snapshot cuối cùng khi destroy
  storage_encrypted       = var.db_storage_encrypted

}

resource "aws_db_subnet_group" "read_replica_subnet_group" {
  name       = "${module.region-z.name}-rds-read-replica-subnet-group"
  subnet_ids = module.region-z.private_subnets # Sử dụng private subnets

  tags = {
    Name = "${module.region-z.name}-rds-read-replica-subnet-group"
  }
}


resource "aws_db_instance" "read_replica" {
  provider = aws.region-z

  identifier          = "${module.region-z.name}-rds-read-replica"
  instance_class      = var.db_instance_class
  replicate_source_db = var.primary_rds_instance_arn

  # Các thuộc tính khác cho replica
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.read_replica_subnet_group.name
  skip_final_snapshot  = true            # Thường thì replica không cần final snapshot
  storage_encrypted    = true            # Bắt buộc phải mã hóa nếu nguồn đã được mã hóa
  kms_key_id           = var.kms_key_arn # Cung cấp KMS key ở region đích

  tags = { Name = "${module.region-z.name}-rds-read-replica" }
}

data "aws_caller_identity" "current" {}

module "s3" {
  source            = "../modules/s3"
  bucket_name       = "quic1-intern-bucket-${data.aws_caller_identity.current.account_id}-z"
  enable_versioning = true
  tags = {
    ManagedBy = "terraform"
  }
}

module "sns" {
  source             = "../modules/sns"
  topic_name         = "region-z-alarms-topic"
  notification_email = var.admin_email
}

module "monitoring" {
  source = "../modules/monitoring"

  name_prefix              = "region-z"
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
