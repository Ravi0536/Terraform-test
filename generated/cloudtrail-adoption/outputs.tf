output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.tos_dev_agentic.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.tos_dev_agentic.arn
}

output "arn" {
  description = "The ARN of the SNS topic."
  value       = aws_sns_topic.style_guide_proof.arn
}

output "id" {
  description = "The ARN of the SNS topic (same as arn; the provider exposes this as the resource ID)."
  value       = aws_sns_topic.style_guide_proof.id
}

output "name" {
  description = "The name of the SNS topic."
  value       = aws_sns_topic.style_guide_proof.name
}

output "owner" {
  description = "The AWS account ID of the SNS topic owner."
  value       = aws_sns_topic.style_guide_proof.owner
}

output "queue_id" {
  description = "URL of the SQS queue (same as queue_url)."
  value       = aws_sqs_queue.tos_lane_jira_0821234621.id
}

output "queue_url" {
  description = "URL of the created Amazon SQS queue."
  value       = aws_sqs_queue.tos_lane_jira_0821234621.url
}

output "queue_arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.tos_lane_jira_0821234621.arn
}

output "queue_name" {
  description = "Name of the SQS queue."
  value       = aws_sqs_queue.tos_lane_jira_0821234621.name
}
