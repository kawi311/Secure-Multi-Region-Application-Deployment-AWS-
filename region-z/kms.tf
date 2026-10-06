resource "aws_kms_key" "rds_snapshot_replication" {
  description             = "KMS key for encrypting replicated RDS snapshots from region-a"
  deletion_window_in_days = 7

  tags = {
    Name = "rds-snapshot-replication-key"
  }
}

output "rds_snapshot_replication_kms_key_arn" {
  description = "ARN of the KMS key for RDS snapshot replication"
  value       = aws_kms_key.rds_snapshot_replication.arn
}
