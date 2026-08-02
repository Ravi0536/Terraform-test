output "bucket_id" {
  description = "Name / ID of the S3 bucket."
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.main.arn
}

output "bucket_region" {
  description = "AWS region where the bucket resides."
  value       = aws_s3_bucket.main.region
}

output "bucket_domain_name" {
  description = "The bucket-regional domain name."
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "encryption_enabled" {
  description = "Whether server-side encryption configuration is managed by this module."
  value       = var.server_side_encryption != null
}

output "public_access_block_enabled" {
  description = "Whether the public-access block is managed by this module."
  value       = var.public_access_block != null
}

output "object_ownership" {
  description = "The object ownership setting applied to the bucket."
  value       = var.object_ownership
}
