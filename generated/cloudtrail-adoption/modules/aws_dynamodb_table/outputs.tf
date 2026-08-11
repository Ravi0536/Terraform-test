output "id" {
  description = "The ID of the aws_dynamodb_table managed by this module."
  value       = aws_dynamodb_table.this.id
}

output "arn" {
  description = "The ARN of the aws_dynamodb_table managed by this module."
  value       = aws_dynamodb_table.this.arn
}

output "name" {
  description = "The name of the aws_dynamodb_table managed by this module."
  value       = var.name
}

