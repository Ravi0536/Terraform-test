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

variable "queue_name" {
  description = "Name of the SQS queue. Must be 1–80 characters using uppercase and lowercase ASCII letters, numbers, underscores, and hyphens. FIFO queues must end with '.fifo'."
  type        = string
  default     = "tos-lane-jira-0821234621"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,80}(\\.fifo)?$", var.queue_name))
    error_message = "Queue name must be 1–80 characters of letters, numbers, underscores, or hyphens (optionally ending in .fifo for FIFO queues)."
  }
}


variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values: 'messageGroup', 'queue'."
  type        = string
  default     = null

  validation {
    condition     = var.deduplication_scope == null || contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "deduplication_scope must be 'messageGroup' or 'queue' when set."
  }
}

variable "delay_seconds" {
  description = "Time in seconds that delivery of all messages in the queue will be delayed. Valid values: 0–900."
  type        = number
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900."
  }
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If false, a standard queue is created."
  type        = bool
  default     = false
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values: 'perQueue', 'perMessageGroupId'."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "fifo_throughput_limit must be 'perQueue' or 'perMessageGroupId' when set."
  }
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Length of time in seconds for which Amazon SQS can reuse a data key to encrypt or decrypt messages. Valid values: 60–86400."
  type        = number
  default     = null

  validation {
    condition     = var.kms_data_key_reuse_period_seconds == null || (var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400)
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400 when set."
  }
}


variable "max_message_size" {
  description = "Limit of how many bytes a message can contain before Amazon SQS rejects it. Valid values: 1024–1048576."
  type        = number
  default     = 262144

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 1048576
    error_message = "max_message_size must be between 1024 (1 KiB) and 1048576 (1024 KiB)."
  }
}

variable "message_retention_seconds" {
  description = "Number of seconds Amazon SQS retains a message. Valid values: 60–1209600."
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 (1 minute) and 1209600 (14 days)."
  }
}


variable "receive_wait_time_seconds" {
  description = "Time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. Valid values: 0–20."
  type        = number
  default     = 0

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20."
  }
}

variable "redrive_allow_policy" {
  description = "JSON policy to set up the Dead Letter Queue redrive permission. When set, Terraform performs drift detection on this value."
  type        = string
  default     = null
}

variable "redrive_policy" {
  description = "JSON policy to configure a Dead Letter Queue. When set, Terraform performs drift detection on this value."
  type        = string
  default     = null
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
  type        = bool
  default     = null
}


variable "visibility_timeout_seconds" {
  description = "Visibility timeout for the queue in seconds. Valid values: 0–43200."
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200 (12 hours)."
  }
}
