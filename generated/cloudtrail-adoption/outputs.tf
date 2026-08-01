output "cloudtrail_bucket_id" {
  description = "ID of the CloudTrail S3 bucket"
  value       = module.cloudtrail_bucket.id
}

output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.cloudtrail_bucket.arn
}

output "cloudtrail_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = module.cloudtrail_bucket.name
}
