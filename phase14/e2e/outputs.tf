output "bucket_id" {
  description = "Name / ID of the adopted S3 bucket."
  value       = module.cf_templates_bucket.bucket_id
}

output "bucket_arn" {
  description = "ARN of the adopted S3 bucket."
  value       = module.cf_templates_bucket.bucket_arn
}

output "bucket_region" {
  description = "AWS region where the adopted S3 bucket resides."
  value       = module.cf_templates_bucket.bucket_region
}

output "bucket_domain_name" {
  description = "Bucket-regional domain name (useful for constructing endpoint URLs)."
  value       = module.cf_templates_bucket.bucket_domain_name
}
