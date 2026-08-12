variable "aws_region" {
  description = "AWS region in which the SNS topic will be created."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. \"us-east-1\"."
  }
}

variable "sns_topic_config" {
  description = "Full configuration object for the SNS topic."

  type = object({
    # Core identity
    name         = string
    display_name = optional(string)

    # FIFO
    fifo_topic                  = optional(bool, false)
    content_based_deduplication = optional(bool, false)
    fifo_throughput_scope       = optional(string)
    archive_policy              = optional(string)

    # Policies
    policy          = optional(string)
    delivery_policy = optional(string)

    # Encryption
    kms_master_key_id = optional(string)

    # Signing & tracing
    signature_version = optional(number)
    tracing_config    = optional(string)

    # Delivery feedback – Application endpoint
    application_success_feedback_role_arn    = optional(string)
    application_success_feedback_sample_rate = optional(number)
    application_failure_feedback_role_arn    = optional(string)

    # Delivery feedback – HTTP(S) endpoint
    http_success_feedback_role_arn    = optional(string)
    http_success_feedback_sample_rate = optional(number)
    http_failure_feedback_role_arn    = optional(string)

    # Delivery feedback – Lambda endpoint
    lambda_success_feedback_role_arn    = optional(string)
    lambda_success_feedback_sample_rate = optional(number)
    lambda_failure_feedback_role_arn    = optional(string)

    # Delivery feedback – SQS endpoint
    sqs_success_feedback_role_arn    = optional(string)
    sqs_success_feedback_sample_rate = optional(number)
    sqs_failure_feedback_role_arn    = optional(string)

    # Delivery feedback – Firehose endpoint
    firehose_success_feedback_role_arn    = optional(string)
    firehose_success_feedback_sample_rate = optional(number)
    firehose_failure_feedback_role_arn    = optional(string)
  })

  # Default matches the real resource being created – no -var flag needed.
  default = {
    name = "delivery-naming-proof"
  }

  validation {
    condition     = length(var.sns_topic_config.name) >= 1 && length(var.sns_topic_config.name) <= 256
    error_message = "SNS topic name must be between 1 and 256 characters long."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]+(\\.fifo)?$", var.sns_topic_config.name))
    error_message = "SNS topic name must contain only uppercase/lowercase letters, numbers, underscores, and hyphens. FIFO topics must end with \".fifo\"."
  }

  validation {
    condition = var.sns_topic_config.fifo_throughput_scope == null || contains(
      ["Topic", "MessageGroup"],
      var.sns_topic_config.fifo_throughput_scope
    )
    error_message = "fifo_throughput_scope must be either \"Topic\" or \"MessageGroup\"."
  }

  validation {
    condition = var.sns_topic_config.tracing_config == null || contains(
      ["PassThrough", "Active"],
      var.sns_topic_config.tracing_config
    )
    error_message = "tracing_config must be either \"PassThrough\" or \"Active\"."
  }

  validation {
    condition = var.sns_topic_config.signature_version == null || contains(
      [1, 2],
      var.sns_topic_config.signature_version
    )
    error_message = "signature_version must be 1 (SHA1) or 2 (SHA256)."
  }

  validation {
    condition = alltrue([
      for rate in compact([
        tostring(coalesce(var.sns_topic_config.application_success_feedback_sample_rate, -1)),
        tostring(coalesce(var.sns_topic_config.http_success_feedback_sample_rate, -1)),
        tostring(coalesce(var.sns_topic_config.lambda_success_feedback_sample_rate, -1)),
        tostring(coalesce(var.sns_topic_config.sqs_success_feedback_sample_rate, -1)),
        tostring(coalesce(var.sns_topic_config.firehose_success_feedback_sample_rate, -1)),
      ]) :
      tonumber(rate) == -1 || (tonumber(rate) >= 0 && tonumber(rate) <= 100)
    ])
    error_message = "All success_feedback_sample_rate values must be between 0 and 100."
  }
}
