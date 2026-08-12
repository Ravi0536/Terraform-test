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
