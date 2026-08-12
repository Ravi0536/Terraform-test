variable "topic_config" {
  description = "Configuration for the SNS topic."
  type = object({
    # Core identity
    name         = string
    display_name = optional(string)

    # Encryption
    kms_master_key_id = optional(string)

    # Policies
    policy          = optional(string)
    delivery_policy = optional(string)
    archive_policy  = optional(string)

    # FIFO settings
    fifo_topic                  = optional(bool, false)
    content_based_deduplication = optional(bool, false)
    fifo_throughput_scope       = optional(string)

    # Observability
    tracing_config    = optional(string)
    signature_version = optional(number)

    # Application endpoint feedback
    application_success_feedback_role_arn    = optional(string)
    application_success_feedback_sample_rate = optional(number)
    application_failure_feedback_role_arn    = optional(string)

    # HTTP endpoint feedback
    http_success_feedback_role_arn    = optional(string)
    http_success_feedback_sample_rate = optional(number)
    http_failure_feedback_role_arn    = optional(string)

    # Lambda endpoint feedback
    lambda_success_feedback_role_arn    = optional(string)
    lambda_success_feedback_sample_rate = optional(number)
    lambda_failure_feedback_role_arn    = optional(string)

    # SQS endpoint feedback
    sqs_success_feedback_role_arn    = optional(string)
    sqs_success_feedback_sample_rate = optional(number)
    sqs_failure_feedback_role_arn    = optional(string)

    # Firehose endpoint feedback
    firehose_success_feedback_role_arn    = optional(string)
    firehose_success_feedback_sample_rate = optional(number)
    firehose_failure_feedback_role_arn    = optional(string)
  })

  default = {
    name = "vendor-naming-proof"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,256}(\\.fifo)?$", var.topic_config.name))
    error_message = "Topic name must be 1-256 characters using only uppercase/lowercase ASCII letters, numbers, underscores, and hyphens. FIFO topics must end with '.fifo'."
  }

  validation {
    condition     = var.topic_config.fifo_topic == true ? endswith(var.topic_config.name, ".fifo") : true
    error_message = "FIFO topics must have a name ending with '.fifo'."
  }

  validation {
    condition     = var.topic_config.content_based_deduplication == true ? var.topic_config.fifo_topic == true : true
    error_message = "content_based_deduplication can only be enabled for FIFO topics (fifo_topic = true)."
  }

  validation {
    condition     = var.topic_config.archive_policy != null ? var.topic_config.fifo_topic == true : true
    error_message = "archive_policy can only be set for FIFO topics (fifo_topic = true)."
  }

  validation {
    condition     = var.topic_config.fifo_throughput_scope != null ? contains(["Topic", "MessageGroup"], var.topic_config.fifo_throughput_scope) : true
    error_message = "fifo_throughput_scope must be either 'Topic' or 'MessageGroup'."
  }

  validation {
    condition     = var.topic_config.tracing_config != null ? contains(["PassThrough", "Active"], var.topic_config.tracing_config) : true
    error_message = "tracing_config must be either 'PassThrough' or 'Active'."
  }

  validation {
    condition     = var.topic_config.signature_version != null ? contains([1, 2], var.topic_config.signature_version) : true
    error_message = "signature_version must be 1 (SHA1) or 2 (SHA256)."
  }

  validation {
    condition = alltrue([
      for rate in compact([
        tostring(var.topic_config.application_success_feedback_sample_rate),
        tostring(var.topic_config.http_success_feedback_sample_rate),
        tostring(var.topic_config.lambda_success_feedback_sample_rate),
        tostring(var.topic_config.sqs_success_feedback_sample_rate),
        tostring(var.topic_config.firehose_success_feedback_sample_rate),
      ]) : tonumber(rate) >= 0 && tonumber(rate) <= 100
    ])
    error_message = "All success_feedback_sample_rate values must be between 0 and 100."
  }
}
