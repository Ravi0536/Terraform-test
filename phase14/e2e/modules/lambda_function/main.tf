resource "aws_lambda_function" "main" {
  function_name = var.function_name
  description   = var.description
  role          = var.role_arn
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory_size
  timeout       = var.timeout
  architectures = var.architectures

  # filename is required by the schema when package_type = "Zip".
  # During adoption the real deployment package is already in place;
  # this placeholder satisfies the schema constraint. The actual
  # source-code path is managed out-of-band (e.g. CI/CD pipeline).
  filename = var.filename

  lifecycle {
    ignore_changes = [
      # The deployment package is managed externally; ignore local filename drift.
      filename,
      source_code_hash,
    ]
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      log_format = logging_config.value.log_format
      log_group  = logging_config.value.log_group
    }
  }

  tags = var.tags
}
