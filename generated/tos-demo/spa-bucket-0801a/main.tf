resource "aws_s3_bucket" "tos_dev_spa_346589946607" {
  bucket = "tos-dev-spa-346589946607"

  tags = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    service     = "tos"
  }
}

import {
  to = aws_s3_bucket.tos_dev_spa_346589946607
  id = "tos-dev-spa-346589946607"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tos_dev_spa_346589946607" {
  bucket = aws_s3_bucket.tos_dev_spa_346589946607.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.tos_dev_spa_346589946607
  id = "tos-dev-spa-346589946607"
}

resource "aws_s3_bucket_public_access_block" "tos_dev_spa_346589946607" {
  bucket                  = aws_s3_bucket.tos_dev_spa_346589946607.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

import {
  to = aws_s3_bucket_public_access_block.tos_dev_spa_346589946607
  id = "tos-dev-spa-346589946607"
}

resource "aws_s3_bucket_policy" "tos_dev_spa_346589946607" {
  bucket = aws_s3_bucket.tos_dev_spa_346589946607.id
  policy = "{\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::346589946607:distribution/E39MQ62UAS777U\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::tos-dev-spa-346589946607/*\",\"Sid\":\"AllowCloudFrontRead\"}],\"Version\":\"2012-10-17\"}"
}

import {
  to = aws_s3_bucket_policy.tos_dev_spa_346589946607
  id = "tos-dev-spa-346589946607"
}

resource "aws_s3_bucket_ownership_controls" "tos_dev_spa_346589946607" {
  bucket = aws_s3_bucket.tos_dev_spa_346589946607.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

import {
  to = aws_s3_bucket_ownership_controls.tos_dev_spa_346589946607
  id = "tos-dev-spa-346589946607"
}
