variable "name" {
  description = "Friendly name of the IAM role."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "IAM role name must be between 1 and 64 characters."
  }
}

variable "assume_role_policy" {
  description = "JSON policy document that grants entities permission to assume the role."
  type        = string
}

variable "description" {
  description = "Optional description for the IAM role."
  type        = string
  default     = null
}

variable "path" {
  description = "Path for the IAM role. Defaults to '/'."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (3600–43200). Defaults to 3600."
  type        = number
  default     = null

  validation {
    condition     = var.max_session_duration == null || (var.max_session_duration >= 3600 && var.max_session_duration <= 43200)
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permissions_boundary" {
  description = "ARN of the IAM policy used as a permissions boundary."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
