resource "aws_s3_bucket" "this" {
  bucket = var.name
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.server_side_encryption != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.server_side_encryption.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm = var.server_side_encryption.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.public_access_block != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy_document != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy_document
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-trail-logs"
    status = "Enabled"

    filter {
    }

    expiration {
      days = 3
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
