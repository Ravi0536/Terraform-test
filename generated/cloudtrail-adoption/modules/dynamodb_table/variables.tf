variable "attributes" {
  description = "List of attribute definitions (hash key, range key, GSI/LSI keys)."
  type = list(object({
    name = string
    type = string
  }))
}

variable "billing_mode" {
  description = "Billing mode for the table. Valid values: PROVISIONED, PAY_PER_REQUEST."
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
}

variable "hash_key" {
  description = "Attribute name to use as the hash (partition) key."
  type        = string
}

variable "name" {
  description = "Unique name for the DynamoDB table."
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to the table."
  type        = map(string)
  default     = {}
}
