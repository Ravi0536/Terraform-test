variable "aws_region" {
  description = "AWS region in which to deploy resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. us-east-1."
  }
}

variable "table_name" {
  description = "Name of the DynamoDB table to create."
  type        = string

  validation {
    condition     = length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "DynamoDB table names must be between 3 and 255 characters."
  }
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. Valid values are PROVISIONED or PAY_PER_REQUEST."
  type        = string

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "billing_mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "hash_key" {
  description = "Attribute name used as the partition (hash) key for the table."
  type        = string
}

variable "attributes" {
  description = "List of attribute definitions for the table. Each entry must include name (string) and type (S, N, or B)."
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition = alltrue([
      for a in var.attributes : contains(["S", "N", "B"], a.type)
    ])
    error_message = "Each attribute type must be S (String), N (Number), or B (Binary)."
  }
}

variable "tags" {
  description = "Map of tags to apply to all resources in this bundle."
  type        = map(string)
}
