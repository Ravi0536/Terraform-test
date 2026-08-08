output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.main.arn
}

output "table_id" {
  description = "Terraform resource ID of the DynamoDB table (the table name)."
  value       = aws_dynamodb_table.main.id
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.main.name
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB stream. Non-empty only when stream_enabled is true."
  value       = aws_dynamodb_table.main.stream_arn
}
