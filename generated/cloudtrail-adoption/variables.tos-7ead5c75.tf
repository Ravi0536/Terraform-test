# ---------------------------------------------------------------------------
# variables.tf — input declarations (alphabetical)
# ---------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region in which the SQS queue will be created."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. \"us-east-1\"."
  }
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values: \"messageGroup\", \"queue\"."
  type        = string
  default     = null

  validation {
    condition     = var.deduplication_scope == null || contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "deduplication_scope must be \"messageGroup\" or \"queue\" (or null to use the provider default)."
  }
}

variable "delay_seconds" {
  description = "Seconds to delay delivery of all messages in the queue (0–900)."
  type        = number
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900."
  }
}

variable "fifo_queue" {
  description = "Set to true to create a FIFO queue. The queue name must end with \".fifo\"."
  type        = bool
  default     = false
}

variable "fifo_throughput_limit" {
  description = "FIFO throughput quota scope. Valid values: \"perQueue\", \"perMessageGroupId\"."
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "fifo_throughput_limit must be \"perQueue\" or \"perMessageGroupId\" (or null to use the provider default)."
  }
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Seconds SQS can reuse a KMS data key (60–86400). Applicable only when kms_master_key_id is set."
  type        = number
  default     = null

  validation {
    condition     = var.kms_data_key_reuse_period_seconds == null || (var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400)
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400."
  }
}

variable "kms_master_key_id" {
  description = "ID or alias of the AWS KMS CMK used for SSE-KMS encryption. Leave null to disable SSE-KMS."
  type        = string
  default     = null
}

variable "max_message_size" {
  description = "Maximum message size in bytes (1024–1048576)."
  type        = number
  default     = 262144

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 1048576
    error_message = "max_message_size must be between 1024 and 1048576 bytes."
  }
}

variable "message_retention_seconds" {
  description = "Seconds Amazon SQS retains a message (60–1209600)."
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "policy" {
  description = "JSON IAM policy document attached to the queue. Omit to leave unmanaged (preferred: use aws_sqs_queue_policy instead)."
  type        = string
  default     = null
}

variable "queue_name" {
  description = "Name of the SQS queue. Must be 1–80 characters of letters, digits, hyphens, and underscores. FIFO queues must end with \".fifo\"."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,80}(\\.fifo)?$", var.queue_name))
    error_message = "queue_name must be 1–80 characters of letters, digits, hyphens, or underscores. FIFO queues must end with \".fifo\"."
  }
}

variable "receive_wait_time_seconds" {
  description = "Seconds a ReceiveMessage call waits for a message before returning (0–20, long polling)."
  type        = number
  default     = 0

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20."
  }
}

variable "redrive_allow_policy" {
  description = "JSON redrive-allow policy that controls which source queues can use this queue as a dead-letter queue."
  type        = string
  default     = null
}

variable "redrive_policy" {
  description = "JSON redrive policy that specifies the dead-letter queue and maxReceiveCount."
  type        = string
  default     = null
}

variable "sqs_managed_sse_enabled" {
  description = "Enable server-side encryption using SQS-owned keys (SSE-SQS)."
  type        = bool
  default     = null
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds (0–43200)."
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200."
  }
}
