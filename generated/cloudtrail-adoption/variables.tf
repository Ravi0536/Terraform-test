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
