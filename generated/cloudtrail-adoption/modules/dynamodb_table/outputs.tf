output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.main.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.main.arn
}

output "table_id" {
  description = "ID (name) of the DynamoDB table."
  value       = aws_dynamodb_table.main.id
}

output "billing_mode" {
  description = "Billing mode of the DynamoDB table."
  value       = aws_dynamodb_table.main.billing_mode
}

output "stream_arn" {
  description = "ARN of the DynamoDB table stream. Only populated when stream_enabled is true."
  value       = aws_dynamodb_table.main.stream_arn
}

output "stream_label" {
  description = "Timestamp label of the DynamoDB table stream. Only populated when stream_enabled is true."
  value       = aws_dynamodb_table.main.stream_label
}
