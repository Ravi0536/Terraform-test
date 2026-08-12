variable "sns_topic_name" {
  description = "Name of the SNS topic. For FIFO topics, the name must end with the '.fifo' suffix."
  type        = string
  default     = "delivery-naming-proof"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,256}(\\.fifo)?$", var.sns_topic_name))
    error_message = "Topic name must be 1-256 characters of ASCII letters, numbers, underscores, or hyphens. FIFO topics must end with '.fifo'."
  }
}

variable "display_name" {
  description = "Display name shown in email notifications from the SNS topic."
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "ID or alias of the AWS KMS key for server-side encryption of the SNS topic. Leave null to use the default AWS-managed key."
  type        = string
  default     = null
}

variable "policy" {
  description = "Fully-formed JSON access policy for the SNS topic. Omit to use the default AWS policy."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "JSON string defining the SNS delivery retry policy for HTTP/HTTPS endpoints."
  type        = string
  default     = null
}

variable "signature_version" {
  description = "Signature version for SNS message signing. 1 = SHA1, 2 = SHA256."
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1 (SHA1) or 2 (SHA256)."
  }
}

variable "tracing_config" {
  description = "AWS X-Ray tracing mode for the SNS topic. Valid values: 'PassThrough', 'Active'."
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "tracing_config must be 'PassThrough' or 'Active'."
  }
}

# ---------------------------------------------------------------------------
# FIFO settings
# ---------------------------------------------------------------------------

variable "fifo_topic" {
  description = "Set to true to create a FIFO (first-in-first-out) SNS topic. The topic name must end with '.fifo'."
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Scope for FIFO deduplication to enable high-throughput mode. Valid values: 'Topic', 'MessageGroup'. Only applies to FIFO topics."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be 'Topic' or 'MessageGroup'."
  }
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics."
  type        = bool
  default     = false
}

variable "archive_policy" {
  description = "JSON string defining the message archive policy for FIFO topics."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Application endpoint delivery status feedback
# ---------------------------------------------------------------------------

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback logs for Application endpoints."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage (0-100) of successfully delivered Application endpoint messages to sample for CloudWatch logging."
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null || (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "application_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role ARN for CloudWatch Logs failure feedback for Application endpoints."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# HTTP endpoint delivery status feedback
# ---------------------------------------------------------------------------

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback logs for HTTP/HTTPS endpoints."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage (0-100) of successfully delivered HTTP/HTTPS endpoint messages to sample for CloudWatch logging."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "http_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role ARN for CloudWatch Logs failure feedback for HTTP/HTTPS endpoints."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Lambda endpoint delivery status feedback
# ---------------------------------------------------------------------------

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback logs for Lambda endpoints."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage (0-100) of successfully delivered Lambda endpoint messages to sample for CloudWatch logging."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "lambda_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN for CloudWatch Logs failure feedback for Lambda endpoints."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# SQS endpoint delivery status feedback
# ---------------------------------------------------------------------------

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback logs for SQS endpoints."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage (0-100) of successfully delivered SQS endpoint messages to sample for CloudWatch logging."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "sqs_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role ARN for CloudWatch Logs failure feedback for SQS endpoints."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Firehose endpoint delivery status feedback
# ---------------------------------------------------------------------------

variable "firehose_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback logs for Kinesis Data Firehose endpoints."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage (0-100) of successfully delivered Firehose endpoint messages to sample for CloudWatch logging."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role ARN for CloudWatch Logs failure feedback for Kinesis Data Firehose endpoints."
  type        = string
  default     = null
}
