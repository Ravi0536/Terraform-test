variable "name" {
  description = "Unique name of the DynamoDB table within the region."
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput. Valid values: PROVISIONED, PAY_PER_REQUEST."
  type        = string

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "billing_mode must be PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "hash_key" {
  description = "Attribute to use as the hash (partition) key. Must be defined in attributes."
  type        = string
}

variable "attributes" {
  description = "List of attribute definitions for hash/range keys. Each attribute requires a name and type (S, N, or B)."
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for a in var.attributes : contains(["S", "N", "B"], a.type)
    ])
    error_message = "Each attribute type must be S (string), N (number), or B (binary)."
  }
}

variable "point_in_time_recovery_enabled" {
  description = "Whether point-in-time recovery is enabled for the table."
  type        = bool
  default     = false
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled for the table."
  type        = bool
  default     = false
}

variable "table_class" {
  description = "Storage class of the table. Valid values: STANDARD, STANDARD_INFREQUENT_ACCESS. Defaults to STANDARD when null."
  type        = string
  default     = null

  validation {
    condition = (
      var.table_class == null ||
      contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    )
    error_message = "table_class must be STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "stream_enabled" {
  description = "Whether DynamoDB Streams are enabled on the table."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type when stream_enabled is true. Valid values: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type        = string
  default     = null

  validation {
    condition = (
      var.stream_view_type == null ||
      contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    )
    error_message = "stream_view_type must be KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES."
  }
}
