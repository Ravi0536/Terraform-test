output "arn" {
  description = "ARN of the SNS topic."
  value       = aws_sns_topic.vendor_naming_proof.arn
}

output "id" {
  description = "ARN of the SNS topic (same as arn; the provider's canonical id attribute)."
  value       = aws_sns_topic.vendor_naming_proof.id
}

output "name" {
  description = "Name of the SNS topic."
  value       = aws_sns_topic.vendor_naming_proof.name
}

output "owner" {
  description = "AWS account ID of the SNS topic owner."
  value       = aws_sns_topic.vendor_naming_proof.owner
}

output "beginning_archive_time" {
  description = "Oldest timestamp at which a FIFO topic subscriber can start a replay (FIFO topics only)."
  value       = aws_sns_topic.vendor_naming_proof.beginning_archive_time
}
