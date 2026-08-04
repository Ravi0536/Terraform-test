output "id" {
  description = "Name / ID of the Lambda function."
  value       = aws_lambda_function.main.id
}

output "arn" {
  description = "ARN of the Lambda function."
  value       = aws_lambda_function.main.arn
}

output "name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.main.function_name
}

output "invoke_arn" {
  description = "ARN used to invoke the Lambda function from API Gateway."
  value       = aws_lambda_function.main.invoke_arn
}

output "qualified_arn" {
  description = "ARN with version number (populated when publish = true)."
  value       = aws_lambda_function.main.qualified_arn
}
