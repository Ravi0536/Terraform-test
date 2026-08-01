variable "name" {
  description = "Name of the S3 bucket (the \"bucket\" argument). Defaults to the adopted live value."
  type        = string
  default     = "tos-dev-cloudtrail-346589946607"
}

variable "tags" {
  description = "Tags applied to the S3 bucket. Defaults to the adopted live tags."
  type        = map(string)
  default = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    service     = "tos"
  }
}

variable "server_side_encryption" {
  description = "Default server-side encryption rule for the bucket. null leaves it unmanaged."
  type = object({
    sse_algorithm      = string
    bucket_key_enabled = optional(bool, false)
  })
  default = {
    bucket_key_enabled = false
    sse_algorithm      = "AES256"
  }
}

variable "public_access_block" {
  description = "Public access block settings for the bucket. null leaves it unmanaged."
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "policy_document" {
  description = "Bucket policy JSON document. null attaches no policy."
  type        = string
  default     = "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Condition\":{\"StringEquals\":{\"aws:SourceArn\":\"arn:aws:cloudtrail:us-east-1:346589946607:trail/tos-dev-events\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::tos-dev-cloudtrail-346589946607\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"aws:SourceArn\":\"arn:aws:cloudtrail:us-east-1:346589946607:trail/tos-dev-events\",\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::tos-dev-cloudtrail-346589946607/AWSLogs/346589946607/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
}
