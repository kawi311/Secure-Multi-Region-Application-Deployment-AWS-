
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
  force_destroy = true # Thêm dòng này để cho phép xóa bucket không rỗng
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count = var.enable_replication ? 1 : 0

  # Versioning must be enabled on the source bucket before replication can be configured.
  # The destination bucket must also have versioning enabled. While we can't enforce that
  # on the destination bucket from this module, this dependency is crucial for the source.
  depends_on = [aws_s3_bucket_versioning.this]

  role   = var.replication_iam_role_arn
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket = var.replication_destination_bucket_arn
    }

    delete_marker_replication {
      status = "Enabled"
    }

    filter {}
  }
}
