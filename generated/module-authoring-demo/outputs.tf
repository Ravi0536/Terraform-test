output "table_id" {
  description = "ID (name) of the DynamoDB table."
  value       = module.aws_dynamodb_table.id
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.aws_dynamodb_table.arn
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.aws_dynamodb_table.name
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream, if enabled."
  value       = module.aws_dynamodb_table.stream_arn
}

output "table_stream_label" {
  description = "Timestamp of the DynamoDB table stream, if enabled."
  value       = module.aws_dynamodb_table.stream_label
}
