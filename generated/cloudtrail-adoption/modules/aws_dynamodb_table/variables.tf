variable "name" {
  description = "Name of the aws_dynamodb_table this module manages (its \"name\" argument). Defaults to the adopted live value."
  type        = string
  default     = "tos-mod-e2e-orders"
}

variable "tags" {
  description = "Tags applied to the aws_dynamodb_table this module manages. Defaults to the adopted live tags."
  type        = map(string)
  default = {
    env        = "test"
    managed-by = "tos-e2e"
  }
}

variable "billing_mode" {
  description = "Billing mode for the table managed by this module (PROVISIONED or PAY_PER_REQUEST)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Attribute name of the partition key for the table managed by this module."
  type        = string
  default     = "id"
}

