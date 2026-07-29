resource "aws_s3_bucket" "managed" {
  bucket = "tos-managed-p15-e2e-346589946607-pub0729b"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    "tos:managed-by" = "tos"
    "tos:phase"      = "15-02"
    "tos:purpose"    = "disposable-e2e"
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
  description = "TOS-managed disposable S3 bucket ARN."
  value       = aws_s3_bucket.managed.arn
}
