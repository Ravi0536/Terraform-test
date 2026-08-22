variable "message_retention_seconds" {
  description = "Number of seconds Amazon SQS retains a message (60–1209600)."
  type        = number
  default     = 1209600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Enable server-side encryption using SQS-managed keys."
  type        = bool
  default     = true
}
