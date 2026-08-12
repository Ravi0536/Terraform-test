variable "aws_region" {
  description = "AWS region where the DynamoDB table is deployed."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region name, e.g. us-east-1."
  }
}

variable "attributes" {
  description = "List of attribute definitions for the DynamoDB table (hash key, range key, and any GSI/LSI key attributes)."
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for a in var.attributes : contains(["S", "N", "B"], a.type)
    ])
    error_message = "Each attribute type must be one of S (string), N (number), or B (binary)."
  }
}

variable "billing_mode" {
  description = "Controls how the table is charged for read/write throughput. Valid values: PROVISIONED, PAY_PER_REQUEST."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "billing_mode must be PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "global_secondary_indexes" {
  description = "List of Global Secondary Index definitions."
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : contains(["ALL", "INCLUDE", "KEYS_ONLY"], gsi.projection_type)
    ])
    error_message = "Each GSI projection_type must be one of ALL, INCLUDE, or KEYS_ONLY."
  }
}

variable "hash_key" {
  description = "Attribute name to use as the hash (partition) key. Must appear in var.attributes."
  type        = string
}

variable "table_name" {
  description = "Unique name of the DynamoDB table within the AWS region."
  type        = string

  validation {
    condition     = length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "table_name must be between 3 and 255 characters."
  }
}

variable "tags" {
  description = "Map of tags to assign to the DynamoDB table."
  type        = map(string)
  default     = {}
}

# ── Core identity ────────────────────────────────────────────────────────────

variable "name" {
  description = "The name of the SNS topic. Must contain only uppercase/lowercase ASCII letters, numbers, underscores, and hyphens (1–256 characters). FIFO topics must end with the '.fifo' suffix."
  type        = string
  default     = "style-guide-proof"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 256
    error_message = "Topic name must be between 1 and 256 characters long."
  }
}

variable "display_name" {
  description = "The display name for the SNS topic (used as the subject in SMS messages)."
  type        = string
  default     = null
}

# ── IAM / access policies ────────────────────────────────────────────────────

variable "policy" {
  description = "Fully-formed AWS resource-based policy document (JSON string) granting principals access to the topic. When null the provider default is used."
  type        = string
  default     = null
}

# ── Delivery ──────────────────────────────────────────────────────────────────

variable "delivery_policy" {
  description = "SNS delivery policy JSON that controls how Amazon SNS retries failed deliveries to HTTP/S endpoints."
  type        = string
  default     = null
}

variable "archive_policy" {
  description = "Message archive policy JSON for FIFO topics. Enables message archiving and replay."
  type        = string
  default     = null
}

# ── FIFO options ──────────────────────────────────────────────────────────────

variable "fifo_topic" {
  description = "Set to true to create a FIFO (first-in-first-out) topic. FIFO topic names must end with '.fifo'."
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Enables higher throughput for FIFO topics. Valid values: 'Topic', 'MessageGroup'. Only applicable when fifo_topic is true."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be 'Topic' or 'MessageGroup' when set."
  }
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics. Only applicable when fifo_topic is true."
  type        = bool
  default     = false
}

# ── Encryption ────────────────────────────────────────────────────────────────

variable "kms_master_key_id" {
  description = "The ID or ARN of an AWS-managed or customer-managed KMS CMK used to encrypt messages at rest. Use 'alias/aws/sns' for the AWS-managed key."
  type        = string
  default     = null
}

# ── Signatures & tracing ──────────────────────────────────────────────────────

variable "signature_version" {
  description = "SHA version used to sign SNS notification messages. Valid values: 1 (SHA1) or 2 (SHA256)."
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1 (SHA1) or 2 (SHA256)."
  }
}

variable "tracing_config" {
  description = "Tracing mode for the SNS topic. Valid values: 'PassThrough', 'Active'."
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "tracing_config must be 'PassThrough' or 'Active' when set."
  }
}

# ── Delivery-status feedback: Application ─────────────────────────────────────

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success-delivery feedback from Application endpoints via CloudWatch Logs."
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
  description = "IAM role ARN that gives SNS write access to CloudWatch Logs for failed Application endpoint deliveries."
  type        = string
  default     = null
}

# ── Delivery-status feedback: HTTP/S ─────────────────────────────────────────

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success-delivery feedback from HTTP/S endpoints via CloudWatch Logs."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered HTTP/S endpoint messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "http_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role ARN that gives SNS write access to CloudWatch Logs for failed HTTP/S endpoint deliveries."
  type        = string
  default     = null
}

# ── Delivery-status feedback: Lambda ─────────────────────────────────────────

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success-delivery feedback from Lambda endpoints via CloudWatch Logs."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Lambda endpoint messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "lambda_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN that gives SNS write access to CloudWatch Logs for failed Lambda endpoint deliveries."
  type        = string
  default     = null
}

# ── Delivery-status feedback: SQS ────────────────────────────────────────────

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success-delivery feedback from SQS endpoints via CloudWatch Logs."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered SQS endpoint messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "sqs_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role ARN that gives SNS write access to CloudWatch Logs for failed SQS endpoint deliveries."
  type        = string
  default     = null
}

# ── Delivery-status feedback: Firehose ───────────────────────────────────────

variable "firehose_success_feedback_role_arn" {
  description = "IAM role ARN permitted to receive success-delivery feedback from Kinesis Data Firehose endpoints via CloudWatch Logs."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage (0–100) of successfully delivered Firehose endpoint messages to sample for CloudWatch Logs."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role ARN that gives SNS write access to CloudWatch Logs for failed Firehose endpoint deliveries."
  type        = string
  default     = null
}
