output "id" {
  description = "ID (name) of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}

output "arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.this.name
}

output "stream_arn" {
  description = "ARN of the DynamoDB table stream. Only populated when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_arn
}

output "stream_label" {
  description = "Timestamp (ISO 8601) of the DynamoDB table stream. Only populated when stream_enabled is true."
  value       = aws_dynamodb_table.this.stream_label
}

output "billing_mode" {
  description = "Billing mode of the DynamoDB table."
  value       = aws_dynamodb_table.this.billing_mode
}

output "hash_key" {
  description = "Partition key attribute name of the DynamoDB table."
  value       = aws_dynamodb_table.this.hash_key
}
