resource "aws_sns_topic" "tos_driver_e2e" {
  name = "tos_driver_e2e"
}

resource "aws_sns_topic" "append_proof" {
  name = var.topic_name

  display_name = var.display_name

  # Encryption
  kms_master_key_id = var.kms_master_key_id

  # Delivery / message policy
  policy          = var.policy
  delivery_policy = var.delivery_policy
  archive_policy  = var.archive_policy

  # FIFO configuration
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  fifo_throughput_scope       = var.fifo_throughput_scope

  # Signature & tracing
  signature_version = var.signature_version
  tracing_config    = var.tracing_config

  # Feedback — Application
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn

  # Feedback — HTTP
  http_success_feedback_role_arn    = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.http_failure_feedback_role_arn

  # Feedback — Lambda
  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn

  # Feedback — SQS
  sqs_success_feedback_role_arn    = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.sqs_failure_feedback_role_arn

  # Feedback — Firehose
  firehose_success_feedback_role_arn    = var.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.firehose_failure_feedback_role_arn

  tags = var.tags
}

# ── Core ──────────────────────────────────────────────────────────────────────

variable "topic_name" {
  description = "Name of the SNS topic. For FIFO topics the name must end with the '.fifo' suffix. Must be 1-256 characters and contain only ASCII letters, numbers, underscores, and hyphens."
  type        = string
  default     = "append-proof"

  validation {
    condition     = length(var.topic_name) >= 1 && length(var.topic_name) <= 256
    error_message = "topic_name must be between 1 and 256 characters."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]+(\\.[Ff][Ii][Ff][Oo])?$", var.topic_name))
    error_message = "topic_name may only contain ASCII letters, numbers, underscores, and hyphens (with an optional .fifo suffix for FIFO topics)."
  }
}

variable "display_name" {
  description = "Human-readable display name shown in SMS messages and the AWS Console. Maximum 100 characters."
  type        = string
  default     = null
}

# ── Encryption ────────────────────────────────────────────────────────────────

variable "kms_master_key_id" {
  description = "ID, alias, or ARN of the AWS KMS key used to encrypt messages at rest. Set to null to use the default AWS-owned key."
  type        = string
  default     = null
}

# ── Policies ──────────────────────────────────────────────────────────────────

variable "policy" {
  description = "Fully-formed JSON IAM access policy for the SNS topic. When null the topic is left with the AWS-generated default policy."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "JSON delivery-retry policy controlling how Amazon SNS retries failed HTTP/HTTPS message deliveries."
  type        = string
  default     = null
}

variable "archive_policy" {
  description = "JSON message-archive policy for FIFO topics. Ignored for standard topics."
  type        = string
  default     = null
}

# ── FIFO configuration ────────────────────────────────────────────────────────

variable "fifo_topic" {
  description = "Set to true to create a FIFO (first-in-first-out) topic. FIFO topic names must end with the '.fifo' suffix."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics. Has no effect on standard topics."
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Deduplication scope for high-throughput FIFO topics. Valid values: 'Topic', 'MessageGroup'. Applicable only when fifo_topic is true."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be 'Topic' or 'MessageGroup' when set."
  }
}

# ── Signature & tracing ───────────────────────────────────────────────────────

variable "signature_version" {
  description = "SNS message signature version. '1' uses SHA1; '2' uses SHA256. Defaults to '1' when null."
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1 or 2."
  }
}

variable "tracing_config" {
  description = "X-Ray active tracing configuration for the topic. Valid values: 'PassThrough', 'Active'."
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "tracing_config must be 'PassThrough' or 'Active'."
  }
}

# ── Delivery feedback — Application ──────────────────────────────────────────

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for successful Application endpoint deliveries."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Application endpoint messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null || (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "application_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for failed Application endpoint deliveries."
  type        = string
  default     = null
}

# ── Delivery feedback — HTTP ──────────────────────────────────────────────────

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for successful HTTP/HTTPS deliveries."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered HTTP/HTTPS messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "http_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for failed HTTP/HTTPS deliveries."
  type        = string
  default     = null
}

# ── Delivery feedback — Lambda ────────────────────────────────────────────────

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for successful Lambda deliveries."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Lambda messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "lambda_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for failed Lambda deliveries."
  type        = string
  default     = null
}

# ── Delivery feedback — SQS ───────────────────────────────────────────────────

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for successful SQS deliveries."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered SQS messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "sqs_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for failed SQS deliveries."
  type        = string
  default     = null
}

# ── Delivery feedback — Firehose ──────────────────────────────────────────────

variable "firehose_success_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for successful Kinesis Data Firehose deliveries."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Firehose messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role ARN that grants Amazon SNS write access to CloudWatch Logs for failed Kinesis Data Firehose deliveries."
  type        = string
  default     = null
}

# ── Tags ──────────────────────────────────────────────────────────────────────

output "topic_arn" {
  description = "ARN of the SNS topic."
  value       = aws_sns_topic.append_proof.arn
}

output "topic_id" {
  description = "ID of the SNS topic (same as its ARN)."
  value       = aws_sns_topic.append_proof.id
}

output "topic_name" {
  description = "Name of the SNS topic."
  value       = aws_sns_topic.append_proof.name
}

output "topic_owner" {
  description = "AWS account ID that owns the SNS topic."
  value       = aws_sns_topic.append_proof.owner
}
