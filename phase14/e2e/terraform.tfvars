aws_region  = "us-east-1"
bucket_name = "cf-templates-tiv18fhdp46w-us-east-1"

tags = {
  tos-drift-test = "1"
}

server_side_encryption = {
  sse_algorithm      = "AES256"
  bucket_key_enabled = false
}

public_access_block = {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

object_ownership = "BucketOwnerEnforced"
