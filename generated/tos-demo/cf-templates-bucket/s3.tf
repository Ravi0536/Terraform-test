resource "aws_s3_bucket" "cf_templates_tiv18fhdp46w_us_east_1" {
  bucket = "cf-templates-tiv18fhdp46w-us-east-1"
  tags = {
    tos-drift-test = "1"
  }
}

import {
  to = aws_s3_bucket.cf_templates_tiv18fhdp46w_us_east_1
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cf_templates_tiv18fhdp46w_us_east_1" {
  bucket = aws_s3_bucket.cf_templates_tiv18fhdp46w_us_east_1.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.cf_templates_tiv18fhdp46w_us_east_1
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

resource "aws_s3_bucket_public_access_block" "cf_templates_tiv18fhdp46w_us_east_1" {
  bucket                  = aws_s3_bucket.cf_templates_tiv18fhdp46w_us_east_1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

import {
  to = aws_s3_bucket_public_access_block.cf_templates_tiv18fhdp46w_us_east_1
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

resource "aws_s3_bucket_ownership_controls" "cf_templates_tiv18fhdp46w_us_east_1" {
  bucket = aws_s3_bucket.cf_templates_tiv18fhdp46w_us_east_1.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

import {
  to = aws_s3_bucket_ownership_controls.cf_templates_tiv18fhdp46w_us_east_1
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

