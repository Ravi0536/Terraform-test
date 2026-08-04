output "id" {
  description = "Name / ID of the IAM role."
  value       = aws_iam_role.main.id
}

output "arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.main.arn
}

output "name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.main.name
}

output "unique_id" {
  description = "Stable unique identifier for the IAM role."
  value       = aws_iam_role.main.unique_id
}
