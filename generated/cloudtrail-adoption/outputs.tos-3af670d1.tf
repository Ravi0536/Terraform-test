output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.dynamodb_table.table_name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.dynamodb_table.table_arn
}

output "table_id" {
  description = "ID (name) of the DynamoDB table."
  value       = module.dynamodb_table.table_id
}

output "billing_mode" {
  description = "Billing mode of the DynamoDB table."
  value       = module.dynamodb_table.billing_mode
}

output "stream_arn" {
  description = "ARN of the DynamoDB table stream (empty string when streams are disabled)."
  value       = module.dynamodb_table.stream_arn
}

output "stream_label" {
  description = "Timestamp label of the DynamoDB table stream (empty string when streams are disabled)."
  value       = module.dynamodb_table.stream_label
}
