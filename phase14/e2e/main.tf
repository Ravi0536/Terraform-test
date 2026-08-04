# ---------------------------------------------------------------------------
# Import blocks — IDs are copied verbatim from the source inventory.
# ---------------------------------------------------------------------------

import {
  to = module.iam_role.aws_iam_role.main
  id = "tos-resource-counter-role"
}

import {
  to = module.lambda_function.aws_lambda_function.main
  id = "tos-resource-counter"
}

# ---------------------------------------------------------------------------
# IAM role module
# ---------------------------------------------------------------------------

module "iam_role" {
  source = "./modules/iam_role"

  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Lambda function module
# ---------------------------------------------------------------------------

module "lambda_function" {
  source = "./modules/lambda_function"

  function_name = var.lambda_function_name
  description   = var.lambda_description
  role_arn      = module.iam_role.arn
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  filename      = var.lambda_filename

  logging_config = var.lambda_logging_config

  tags = var.tags
}
