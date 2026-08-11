output "id" {
  description = "The name/ID of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}

output "arn" {
  description = "The ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.this.name
}

output "stream_arn" {
  description = "The ARN of the DynamoDB table stream. Only available when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_arn
}

output "stream_label" {
  description = "A timestamp (ISO 8601) of the DynamoDB table stream. Only available when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_label
}
