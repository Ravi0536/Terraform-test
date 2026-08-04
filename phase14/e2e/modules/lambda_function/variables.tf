variable "function_name" {
  description = "Unique name for the Lambda function."
  type        = string

  validation {
    condition     = length(var.function_name) > 0 && length(var.function_name) <= 64
    error_message = "Lambda function name must be between 1 and 64 characters."
  }
}

variable "description" {
  description = "Human-readable description of what the Lambda function does."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM execution role for the Lambda function."
  type        = string
}

variable "runtime" {
  description = "Lambda runtime identifier (e.g. python3.12)."
  type        = string

  validation {
    condition = contains([
      "python3.8", "python3.9", "python3.10", "python3.11", "python3.12", "python3.13",
      "nodejs18.x", "nodejs20.x", "nodejs22.x",
      "java11", "java17", "java21",
      "dotnet6", "dotnet8",
      "ruby3.2", "ruby3.3",
      "provided.al2", "provided.al2023",
    ], var.runtime)
    error_message = "Unsupported Lambda runtime identifier."
  }
}

variable "handler" {
  description = "Entry point for the Lambda function (e.g. handler.handler)."
  type        = string
}

variable "filename" {
  description = <<-EOT
    Path to the function's deployment package within the local filesystem.
    Required by the provider schema when package_type is Zip. For adoption
    workflows the real package already exists in AWS; set this to any
    placeholder path — the value is ignored via lifecycle.ignore_changes.
  EOT
  type        = string
  default     = "/dev/null"
}

variable "memory_size" {
  description = "Amount of memory in MB allocated to the Lambda function (128–32768)."
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 32768
    error_message = "memory_size must be between 128 and 32768 MB."
  }
}

variable "timeout" {
  description = "Execution timeout in seconds (1–900)."
  type        = number
  default     = 3

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "timeout must be between 1 and 900 seconds."
  }
}

variable "architectures" {
  description = "Instruction set architecture. Valid values: [\"x86_64\"] or [\"arm64\"]."
  type        = list(string)
  default     = ["x86_64"]

  validation {
    condition     = length(var.architectures) == 1 && contains(["x86_64", "arm64"], var.architectures[0])
    error_message = "architectures must be a single-element list: [\"x86_64\"] or [\"arm64\"]."
  }
}

variable "logging_config" {
  description = "Advanced logging configuration block. Set to null to use Lambda defaults."
  type = object({
    log_format = string
    log_group  = string
  })
  default = null

  validation {
    condition = var.logging_config == null || contains(
      ["Text", "JSON"],
      var.logging_config.log_format
    )
    error_message = "logging_config.log_format must be 'Text' or 'JSON'."
  }
}

variable "tags" {
  description = "Tags to apply to the Lambda function."
  type        = map(string)
  default     = {}
}
