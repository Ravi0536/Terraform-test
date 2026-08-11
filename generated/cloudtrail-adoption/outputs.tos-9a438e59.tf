output "dynamodb_table_id" {
  description = "The name/ID of the DynamoDB table."
  value       = module.aws_dynamodb_table.id
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table."
  value       = module.aws_dynamodb_table.arn
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = module.aws_dynamodb_table.name
}
