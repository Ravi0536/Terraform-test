iam_role_name        = "tos-resource-counter-role"
lambda_function_name = "tos-resource-counter"
lambda_description   = "Counts AWS resources by service - TOS pipeline deployment test subject"
lambda_runtime       = "python3.12"
lambda_handler       = "handler.handler"
lambda_memory_size   = 256
lambda_timeout       = 60

lambda_logging_config = {
  log_format = "Text"
  log_group  = "/aws/lambda/tos-resource-counter"
}

tags = {
  purpose   = "pipeline-deployment-test"
  "tos-e2e" = "true"
}
