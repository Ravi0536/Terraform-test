output "sns_topic_arn" {
  description = "ARN of the SNS topic (also the resource ID)."
  value       = aws_sns_topic.delivery_naming_proof.arn
}

output "sns_topic_id" {
  description = "Terraform resource ID of the SNS topic (same as ARN)."
  value       = aws_sns_topic.delivery_naming_proof.id
}

output "sns_topic_name" {
  description = "Name of the SNS topic."
  value       = aws_sns_topic.delivery_naming_proof.name
}

output "sns_topic_owner" {
  description = "AWS account ID that owns the SNS topic."
  value       = aws_sns_topic.delivery_naming_proof.owner
}
