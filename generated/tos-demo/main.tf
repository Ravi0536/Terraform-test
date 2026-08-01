resource "aws_s3_bucket" "tos_ms_outputs_346589946607" {
  bucket = "tos-ms-outputs-346589946607"

  tags = {
    Project = "tos"
    Stack   = "microservices"
  }
}

import {
  to = aws_s3_bucket.tos_ms_outputs_346589946607
  id = "tos-ms-outputs-346589946607"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tos_ms_outputs_346589946607" {
  bucket = aws_s3_bucket.tos_ms_outputs_346589946607.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.tos_ms_outputs_346589946607
  id = "tos-ms-outputs-346589946607"
}

resource "aws_s3_bucket_ownership_controls" "tos_ms_outputs_346589946607" {
  bucket = aws_s3_bucket.tos_ms_outputs_346589946607.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

import {
  to = aws_s3_bucket_ownership_controls.tos_ms_outputs_346589946607
  id = "tos-ms-outputs-346589946607"
}
