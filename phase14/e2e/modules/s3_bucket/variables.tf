variable "aws_region" {
  description = "AWS region in which the bucket resides (informational; used to derive outputs)."
  type        = string
}

variable "bucket_name" {
  description = "Name (ID) of the S3 bucket managed by this module."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be between 3 and 63 characters long."
  }
}

variable "tags" {
  description = "Map of tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}

variable "server_side_encryption" {
  description = "Default server-side encryption configuration. null disables management of this resource."
  type = object({
    sse_algorithm      = string
    bucket_key_enabled = optional(bool, false)
  })
  default = null

  validation {
    condition = var.server_side_encryption == null || contains(
      ["AES256", "aws:kms", "aws:kms:dsse"],
      var.server_side_encryption.sse_algorithm
    )
    error_message = "sse_algorithm must be one of: AES256, aws:kms, aws:kms:dsse."
  }
}

variable "public_access_block" {
  description = "Public-access-block settings. null disables management of this resource."
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = null
}

variable "object_ownership" {
  description = "Bucket object-ownership rule applied via aws_s3_bucket_ownership_controls."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition = contains(
      ["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"],
      var.object_ownership
    )
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}
