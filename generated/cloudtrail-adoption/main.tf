import {
  to = module.cloudtrail_bucket.aws_s3_bucket.this
  id = "tos-dev-cloudtrail-346589946607"
}

import {
  to = module.cloudtrail_bucket.aws_s3_bucket_server_side_encryption_configuration.this[0]
  id = "tos-dev-cloudtrail-346589946607"
}

import {
  to = module.cloudtrail_bucket.aws_s3_bucket_public_access_block.this[0]
  id = "tos-dev-cloudtrail-346589946607"
}

import {
  to = module.cloudtrail_bucket.aws_s3_bucket_policy.this[0]
  id = "tos-dev-cloudtrail-346589946607"
}

import {
  to = module.cloudtrail_bucket.aws_s3_bucket_lifecycle_configuration.this
  id = "tos-dev-cloudtrail-346589946607"
}

import {
  to = module.cloudtrail_bucket.aws_s3_bucket_ownership_controls.this
  id = "tos-dev-cloudtrail-346589946607"
}

module "cloudtrail_bucket" {
  source = "./modules/s3_bucket"

  name = "tos-dev-cloudtrail-346589946607"

  tags = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    service     = "tos"
  }

  server_side_encryption = {
    bucket_key_enabled = false
    sse_algorithm      = "AES256"
  }

  public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  policy_document = "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Condition\":{\"StringEquals\":{\"aws:SourceArn\":\"arn:aws:cloudtrail:us-east-1:346589946607:trail/tos-dev-events\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::tos-dev-cloudtrail-346589946607\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"aws:SourceArn\":\"arn:aws:cloudtrail:us-east-1:346589946607:trail/tos-dev-events\",\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::tos-dev-cloudtrail-346589946607/AWSLogs/346589946607/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
}
