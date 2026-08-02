variable "aws_region" {
  description = "AWS region in which the S3 bucket resides."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. us-east-1."
  }
}

variable "bucket_name" {
  description = "Name (ID) of the S3 bucket to adopt. Must match the existing bucket name exactly."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be between 3 and 63 characters long."
  }
}

variable "tags" {
  description = "Map of tags applied to every adopted resource."
  type        = map(string)
}

variable "server_side_encryption" {
  description = "Default server-side encryption configuration. Set to null to leave the resource unmanaged."
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
  description = "Public-access-block settings. Set to null to leave the resource unmanaged."
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = null
}

variable "object_ownership" {
  description = "Bucket object-ownership rule. One of BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  type        = string

  validation {
    condition = contains(
      ["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"],
      var.object_ownership
    )
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}
