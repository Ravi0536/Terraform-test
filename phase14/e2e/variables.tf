# ---------------------------------------------------------------------------
# Shared
# ---------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all managed resources."
  type        = map(string)
  default = {
    purpose   = "pipeline-deployment-test"
    "tos-e2e" = "true"
  }
}

# ---------------------------------------------------------------------------
# IAM role
# ---------------------------------------------------------------------------

variable "iam_role_name" {
  description = "Name of the IAM role adopted by this bundle."
  type        = string

  validation {
    condition     = length(var.iam_role_name) > 0 && length(var.iam_role_name) <= 64
    error_message = "IAM role name must be between 1 and 64 characters."
  }
}

# ---------------------------------------------------------------------------
# Lambda function
# ---------------------------------------------------------------------------

variable "lambda_function_name" {
  description = "Name of the Lambda function adopted by this bundle."
  type        = string

  validation {
    condition     = length(var.lambda_function_name) > 0 && length(var.lambda_function_name) <= 64
    error_message = "Lambda function name must be between 1 and 64 characters."
  }
}

variable "lambda_description" {
  description = "Human-readable description of what the Lambda function does."
  type        = string
  default     = ""
}

variable "lambda_runtime" {
  description = "Lambda runtime identifier (e.g. python3.12, nodejs22.x)."
  type        = string

  validation {
    condition = contains([
      "python3.8", "python3.9", "python3.10", "python3.11", "python3.12", "python3.13",
      "nodejs18.x", "nodejs20.x", "nodejs22.x",
      "java11", "java17", "java21",
      "dotnet6", "dotnet8",
      "ruby3.2", "ruby3.3",
      "provided.al2", "provided.al2023",
    ], var.lambda_runtime)
    error_message = "Unsupported Lambda runtime. Choose a currently supported identifier."
  }
}

variable "lambda_handler" {
  description = "Handler entry point for the Lambda function (e.g. handler.handler)."
  type        = string
}

variable "lambda_filename" {
  description = <<-EOT
    Local path to the Lambda deployment package (.zip). Required by the
    provider schema for Zip functions. For pure-adoption workflows this
    value is ignored at runtime via lifecycle.ignore_changes — any
    placeholder string is acceptable.
  EOT
  type        = string
  default     = "/dev/null"
}

variable "lambda_memory_size" {
  description = "Amount of memory in MB allocated to the Lambda function (128–32768 MB)."
  type        = number

  validation {
    condition     = var.lambda_memory_size >= 128 && var.lambda_memory_size <= 32768
    error_message = "Lambda memory_size must be between 128 and 32768 MB."
  }
}

variable "lambda_timeout" {
  description = "Maximum execution time in seconds for the Lambda function (1–900)."
  type        = number

  validation {
    condition     = var.lambda_timeout >= 1 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 1 and 900 seconds."
  }
}

variable "lambda_logging_config" {
  description = "Advanced logging configuration for the Lambda function. Set to null to use Lambda defaults."
  type = object({
    log_format = string
    log_group  = string
  })
  default = null

  validation {
    condition = var.lambda_logging_config == null || contains(
      ["Text", "JSON"],
      var.lambda_logging_config.log_format
    )
    error_message = "lambda_logging_config.log_format must be 'Text' or 'JSON'."
  }
}
