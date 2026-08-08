output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.orders_table.table_arn
}

output "table_id" {
  description = "Name of the DynamoDB table (also its Terraform ID)."
  value       = module.orders_table.table_id
}

output "table_name" {
  description = "Name of the DynamoDB table."
  value       = module.orders_table.table_name
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream. Non-empty only when stream_enabled is true."
  value       = module.orders_table.table_stream_arn
}
