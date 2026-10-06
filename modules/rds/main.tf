# Tạo mật khẩu ngẫu nhiên cho RDS
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Tạo security group cho RDS, chỉ cho phép traffic từ app SG
resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-rds-sg"
  description = "Allow traffic to RDS from the application"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.engine == "mysql" ? 3306 : 5432
    to_port         = var.engine == "mysql" ? 3306 : 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  tags = merge({ Name = "${var.name}-rds-sg" }, var.tags)
}
# Subnet group for RDS
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    {
      Name = "${var.name}-rds-subnet-group"
    },
    var.tags
  )
}

# RDS Instance
resource "aws_db_instance" "this" {
  identifier                = "${var.name}-rds"
  allocated_storage         = var.allocated_storage
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = random_password.db_password.result
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  multi_az                  = var.multi_az
  backup_retention_period   = var.backup_retention_period # Phải lớn hơn 0 để tạo Read Replica
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  storage_encrypted         = var.storage_encrypted
  publicly_accessible       = var.publicly_accessible

  tags = merge({ Name = "${var.name}-rds" }, var.tags)
}
