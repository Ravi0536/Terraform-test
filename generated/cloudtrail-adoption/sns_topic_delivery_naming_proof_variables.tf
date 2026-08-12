# ── General ──────────────────────────────────────────────────────────────────


variable "topic_name" {
  description = "Name of the SNS topic. For FIFO topics the name must end with '.fifo'. Must be 1–256 characters containing only ASCII letters, numbers, underscores, and hyphens."
  type        = string
  default     = "delivery-naming-proof"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,256}(\\.fifo)?$", var.topic_name))
    error_message = "topic_name must be 1–256 characters of ASCII letters, numbers, underscores, or hyphens, optionally ending with '.fifo' for FIFO topics."
  }
}

variable "display_name" {
  description = "Human-readable display name for the SNS topic (used as the SMS message sender name)."
  type        = string
  default     = null
}

# ── Encryption ────────────────────────────────────────────────────────────────

variable "kms_master_key_id" {
  description = "ID or alias of the AWS KMS key used for server-side encryption. Set to null to disable SSE."
  type        = string
  default     = null
}

# ── FIFO ──────────────────────────────────────────────────────────────────────

variable "fifo_topic" {
  description = "When true, creates a FIFO (first-in-first-out) topic. The topic_name must end with '.fifo'."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics. Only valid when fifo_topic is true."
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Throughput scope for FIFO topics. Valid values: 'Topic', 'MessageGroup'. Only valid when fifo_topic is true."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be 'Topic', 'MessageGroup', or null."
  }
}

variable "archive_policy" {
  description = "JSON message archive policy for FIFO topics. Only valid when fifo_topic is true."
  type        = string
  default     = null
}

# ── Policies ─────────────────────────────────────────────────────────────────

variable "policy" {
  description = "Fully-formed JSON IAM resource policy to attach to the topic."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "JSON SNS delivery policy controlling retry and throttle behaviour for HTTP/S subscriptions."
  type        = string
  default     = null
}

# ── Observability ─────────────────────────────────────────────────────────────

variable "tracing_config" {
  description = "X-Ray active tracing mode. Valid values: 'PassThrough', 'Active'."
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "tracing_config must be 'PassThrough', 'Active', or null."
  }
}

variable "signature_version" {
  description = "SNS message signature version. 1 uses SHA1; 2 uses SHA256."
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1, 2, or null."
  }
}

# ── Application endpoint feedback ─────────────────────────────────────────────

variable "application_success_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for successful application endpoint deliveries."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered application endpoint messages to sample in CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null || (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "application_success_feedback_sample_rate must be between 0 and 100, or null."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for failed application endpoint deliveries."
  type        = string
  default     = null
}

# ── HTTP endpoint feedback ────────────────────────────────────────────────────

variable "http_success_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for successful HTTP/S endpoint deliveries."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered HTTP/S endpoint messages to sample in CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "http_success_feedback_sample_rate must be between 0 and 100, or null."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for failed HTTP/S endpoint deliveries."
  type        = string
  default     = null
}

# ── Lambda endpoint feedback ──────────────────────────────────────────────────

variable "lambda_success_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for successful Lambda endpoint deliveries."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Lambda endpoint messages to sample in CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "lambda_success_feedback_sample_rate must be between 0 and 100, or null."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for failed Lambda endpoint deliveries."
  type        = string
  default     = null
}

# ── SQS endpoint feedback ─────────────────────────────────────────────────────

variable "sqs_success_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for successful SQS endpoint deliveries."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered SQS endpoint messages to sample in CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "sqs_success_feedback_sample_rate must be between 0 and 100, or null."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for failed SQS endpoint deliveries."
  type        = string
  default     = null
}

# ── Firehose endpoint feedback ────────────────────────────────────────────────

variable "firehose_success_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for successful Firehose endpoint deliveries."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Firehose endpoint messages to sample in CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100, or null."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "ARN of the IAM role that allows SNS to write CloudWatch Logs for failed Firehose endpoint deliveries."
  type        = string
  default     = null
}
