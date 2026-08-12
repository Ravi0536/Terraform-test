resource "aws_sns_topic" "service_file_proof" {
  name         = var.name
  display_name = var.display_name

  # Encryption
  kms_master_key_id = var.kms_master_key_id

  # FIFO settings
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  fifo_throughput_scope       = var.fifo_throughput_scope
  archive_policy              = var.archive_policy

  # Policies
  policy          = var.policy
  delivery_policy = var.delivery_policy

  # Observability
  signature_version = var.signature_version
  tracing_config    = var.tracing_config

  # Application endpoint feedback
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn

  # HTTP endpoint feedback
  http_success_feedback_role_arn    = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.http_failure_feedback_role_arn

  # Lambda endpoint feedback
  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn

  # SQS endpoint feedback
  sqs_success_feedback_role_arn    = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.sqs_failure_feedback_role_arn

  # Firehose endpoint feedback
  firehose_success_feedback_role_arn    = var.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.firehose_failure_feedback_role_arn
}

variable "name" {
  description = "The name of the SNS topic. Must be 1–256 characters using uppercase/lowercase ASCII letters, numbers, underscores, and hyphens. FIFO topics must end with '.fifo'. Conflicts with name_prefix."
  type        = string
  default     = "service-file-proof"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,256}(\\.fifo)?$", var.name))
    error_message = "Topic name must be 1–256 characters (letters, numbers, underscores, hyphens). FIFO topics must end with '.fifo'."
  }
}

variable "display_name" {
  description = "The display name for the SNS topic (used in email notifications)."
  type        = string
  default     = null
}

variable "policy" {
  description = "The fully-formed AWS access policy document (JSON) for the SNS topic."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The SNS delivery policy as a JSON string controlling retry logic for HTTP/HTTPS endpoints."
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "ID of an AWS-managed or customer-managed KMS key for server-side encryption of the SNS topic."
  type        = string
  default     = null
}

variable "signature_version" {
  description = "The signature version used for SNS message signing. 1 = SHA1, 2 = SHA256."
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1 (SHA1) or 2 (SHA256)."
  }
}

variable "tracing_config" {
  description = "Tracing mode for the SNS topic. Valid values: 'PassThrough' or 'Active'."
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
  description = "Whether to create a FIFO (first-in-first-out) SNS topic. FIFO topic names must end with '.fifo'."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics. Only applicable when fifo_topic is true."
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Throughput scope for high-throughput FIFO topics. Valid values: 'Topic' or 'MessageGroup'. Only applicable when fifo_topic is true."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be 'Topic' or 'MessageGroup'."
  }
}

variable "archive_policy" {
  description = "The message archive policy for FIFO topics as a JSON string."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Application endpoint delivery feedback
# ---------------------------------------------------------------------------

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback for application (mobile push) endpoint deliveries."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered application endpoint messages to sample."
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null || (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "application_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role ARN for logging failed application (mobile push) endpoint delivery attempts to CloudWatch."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# HTTP/HTTPS endpoint delivery feedback
# ---------------------------------------------------------------------------

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback for HTTP/HTTPS endpoint deliveries."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered HTTP/HTTPS endpoint messages to sample."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "http_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role ARN for logging failed HTTP/HTTPS endpoint delivery attempts to CloudWatch."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Lambda endpoint delivery feedback
# ---------------------------------------------------------------------------

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback for Lambda endpoint deliveries."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Lambda endpoint messages to sample."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "lambda_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN for logging failed Lambda endpoint delivery attempts to CloudWatch."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# SQS endpoint delivery feedback
# ---------------------------------------------------------------------------

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback for SQS endpoint deliveries."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered SQS endpoint messages to sample."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "sqs_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role ARN for logging failed SQS endpoint delivery attempts to CloudWatch."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Firehose endpoint delivery feedback
# ---------------------------------------------------------------------------

variable "firehose_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success feedback for Kinesis Data Firehose endpoint deliveries."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Firehose endpoint messages to sample."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role ARN for logging failed Kinesis Data Firehose endpoint delivery attempts to CloudWatch."
  type        = string
  default     = null
}

output "arn" {
  description = "The ARN of the SNS topic."
  value       = aws_sns_topic.service_file_proof.arn
}

output "id" {
  description = "The ARN of the SNS topic (same as arn; Terraform's canonical resource ID)."
  value       = aws_sns_topic.service_file_proof.id
}

output "name" {
  description = "The name of the SNS topic."
  value       = aws_sns_topic.service_file_proof.name
}

output "owner" {
  description = "The AWS account ID that owns the SNS topic."
  value       = aws_sns_topic.service_file_proof.owner
}

output "beginning_archive_time" {
  description = "The oldest timestamp from which a FIFO topic subscriber can start a replay (FIFO topics only)."
  value       = aws_sns_topic.service_file_proof.beginning_archive_time
}
