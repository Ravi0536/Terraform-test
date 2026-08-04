# ---------------------------------------------------------------------------
# IAM role outputs
# ---------------------------------------------------------------------------

output "iam_role_id" {
  description = "Name / ID of the adopted IAM role."
  value       = module.iam_role.id
}

output "iam_role_arn" {
  description = "ARN of the adopted IAM role."
  value       = module.iam_role.arn
}

output "iam_role_name" {
  description = "Name of the adopted IAM role."
  value       = module.iam_role.name
}

# ---------------------------------------------------------------------------
# Lambda function outputs
# ---------------------------------------------------------------------------

output "lambda_function_id" {
  description = "Name / ID of the adopted Lambda function."
  value       = module.lambda_function.id
}

output "lambda_function_arn" {
  description = "ARN of the adopted Lambda function."
  value       = module.lambda_function.arn
}

output "lambda_function_name" {
  description = "Name of the adopted Lambda function."
  value       = module.lambda_function.name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function (used by API Gateway integrations)."
  value       = module.lambda_function.invoke_arn
}
