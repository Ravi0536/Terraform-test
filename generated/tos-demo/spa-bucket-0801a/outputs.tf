output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.tos_dev_spa_346589946607.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.tos_dev_spa_346589946607.arn
}
