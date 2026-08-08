variable "aws_region" {
  description = "AWS region where the DynamoDB table is managed."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. us-east-1."
  }
}

variable "table_config" {
  description = "Configuration for the DynamoDB table being adopted."
  type = object({
    name         = string
    billing_mode = string
    hash_key     = string

    attributes = list(object({
      name = string
      type = string
    }))

    point_in_time_recovery_enabled = bool
    deletion_protection_enabled    = optional(bool, false)
    table_class                    = optional(string, null)
    stream_enabled                 = optional(bool, false)
    stream_view_type               = optional(string, null)
  })

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.table_config.billing_mode)
    error_message = "billing_mode must be PROVISIONED or PAY_PER_REQUEST."
  }

  validation {
    condition = alltrue([
      for a in var.table_config.attributes : contains(["S", "N", "B"], a.type)
    ])
    error_message = "Each attribute type must be S (string), N (number), or B (binary)."
  }

  validation {
    condition = (
      var.table_config.table_class == null ||
      contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_config.table_class)
    )
    error_message = "table_class must be STANDARD or STANDARD_INFREQUENT_ACCESS."
  }

  validation {
    condition = (
      !var.table_config.stream_enabled ||
      (
        var.table_config.stream_view_type != null &&
        contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.table_config.stream_view_type)
      )
    )
    error_message = "stream_view_type must be set to KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES when stream_enabled is true."
  }
}
