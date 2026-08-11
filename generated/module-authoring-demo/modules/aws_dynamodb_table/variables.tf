variable "name" {
  description = "Name of the DynamoDB table."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 255
    error_message = "DynamoDB table name must be between 3 and 255 characters."
  }
}

variable "billing_mode" {
  description = "Controls billing for read/write throughput. Valid values: PROVISIONED or PAY_PER_REQUEST."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "billing_mode must be PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "hash_key" {
  description = "Attribute name to use as the partition (hash) key."
  type        = string
}

variable "range_key" {
  description = "Attribute name to use as the sort (range) key. Omit if not needed."
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "Number of read capacity units. Required when billing_mode is PROVISIONED."
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Number of write capacity units. Required when billing_mode is PROVISIONED."
  type        = number
  default     = null
}

variable "table_class" {
  description = "Storage class of the table. Valid values: STANDARD or STANDARD_INFREQUENT_ACCESS."
  type        = string
  default     = null

  validation {
    condition     = var.table_class == null || contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "table_class must be STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "stream_enabled" {
  description = "Whether DynamoDB Streams are enabled for the table."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Information written to the stream when items are modified."
  type        = string
  default     = null

  validation {
    condition     = var.stream_view_type == null || contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    error_message = "stream_view_type must be one of KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES."
  }
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled for the table."
  type        = bool
  default     = false
}

variable "point_in_time_recovery_enabled" {
  description = "Whether Point-in-Time Recovery is enabled for the table."
  type        = bool
  default     = false
}

variable "server_side_encryption" {
  description = "Server-side encryption settings. Provide enabled = true and an optional kms_key_arn."
  type = object({
    enabled     = bool
    kms_key_arn = optional(string, null)
  })
  default = null
}

variable "ttl" {
  description = "TTL configuration. Set enabled = true and provide the attribute_name for the TTL attribute."
  type = object({
    enabled        = bool
    attribute_name = string
  })
  default = null
}

variable "attributes" {
  description = "Attribute definitions for all key attributes. Each must have name and type (S, N, or B)."
  type = list(object({
    name = string
    type = string
  }))
  default = []

  validation {
    condition     = alltrue([for a in var.attributes : contains(["S", "N", "B"], a.type)])
    error_message = "Each attribute type must be S (String), N (Number), or B (Binary)."
  }
}

variable "global_secondary_indexes" {
  description = "List of Global Secondary Index configurations."
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string, null)
    projection_type    = string
    non_key_attributes = optional(list(string), null)
    read_capacity      = optional(number, null)
    write_capacity     = optional(number, null)
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of Local Secondary Index configurations. Can only be defined at table creation."
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string), null)
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the DynamoDB table."
  type        = map(string)
  default     = {}
}
