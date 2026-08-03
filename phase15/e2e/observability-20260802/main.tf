resource "aws_s3_bucket" "managed" {
  bucket = "tos-managed-e2e-observe-20260803-346589946607"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    "tos:managed-by" = "tos"
    "tos:contract"   = "managed-s3-v1"
    "tos:purpose"    = "managed-infrastructure"
  }
}


resource "aws_s3_bucket_versioning" "managed" {
  bucket = aws_s3_bucket.managed.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "managed" {
  bucket = aws_s3_bucket.managed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "managed" {
  bucket = aws_s3_bucket.managed.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "managed" {
  bucket = aws_s3_bucket.managed.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "bucket_arn" {
  description = "TOS-managed S3 bucket ARN."
  value       = aws_s3_bucket.managed.arn
}
