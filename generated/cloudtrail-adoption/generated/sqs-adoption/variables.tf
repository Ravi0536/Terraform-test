variable "queue_config" {
  description = "Configuration settings for the SQS queue."
  type = object({
    name                      = string
    message_retention_seconds = optional(number, 1209600)
    sqs_managed_sse_enabled   = optional(bool, true)
  })

  default = {
    name                      = "tos-jira-agentic-e2e"
    message_retention_seconds = 1209600
    sqs_managed_sse_enabled   = true
  }

  validation {
    condition     = length(var.queue_config.name) >= 1 && length(var.queue_config.name) <= 80
    error_message = "Queue name must be between 1 and 80 characters."
  }

  validation {
    condition     = var.queue_config.message_retention_seconds >= 60 && var.queue_config.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 (1 minute) and 1209600 (14 days)."
  }
}
