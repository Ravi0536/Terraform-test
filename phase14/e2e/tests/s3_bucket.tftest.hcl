# ---------------------------------------------------------------------------
# Unit tests – run in plan mode; no real AWS credentials required.
# ---------------------------------------------------------------------------

variables {
  aws_region  = "us-east-1"
  bucket_name = "cf-templates-tiv18fhdp46w-us-east-1"
  tags = {
    tos-drift-test = "1"
  }
  server_side_encryption = {
    sse_algorithm      = "AES256"
    bucket_key_enabled = false
  }
  public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
  object_ownership = "BucketOwnerEnforced"
}

# ---------------------------------------------------------------------------
# Validates that the module produces the expected bucket name output.
# ---------------------------------------------------------------------------
run "bucket_name_propagated" {
  command = plan

  assert {
    condition     = module.cf_templates_bucket.bucket_id == "cf-templates-tiv18fhdp46w-us-east-1"
    error_message = "bucket_id output must equal the configured bucket_name."
  }
}

# ---------------------------------------------------------------------------
# Validates that encryption management flag is true when config is supplied.
# ---------------------------------------------------------------------------
run "encryption_enabled_when_config_provided" {
  command = plan

  assert {
    condition     = module.cf_templates_bucket.encryption_enabled == true
    error_message = "encryption_enabled must be true when server_side_encryption is set."
  }
}

# ---------------------------------------------------------------------------
# Validates that public-access-block management flag is true.
# ---------------------------------------------------------------------------
run "public_access_block_enabled" {
  command = plan

  assert {
    condition     = module.cf_templates_bucket.public_access_block_enabled == true
    error_message = "public_access_block_enabled must be true when public_access_block is set."
  }
}

# ---------------------------------------------------------------------------
# Validates that object_ownership output matches input.
# ---------------------------------------------------------------------------
run "object_ownership_propagated" {
  command = plan

  assert {
    condition     = module.cf_templates_bucket.object_ownership == "BucketOwnerEnforced"
    error_message = "object_ownership output must equal the configured value."
  }
}

# ---------------------------------------------------------------------------
# Variable validation: invalid sse_algorithm is rejected.
# ---------------------------------------------------------------------------
run "invalid_sse_algorithm_rejected" {
  command = plan

  variables {
    server_side_encryption = {
      sse_algorithm      = "INVALID"
      bucket_key_enabled = false
    }
  }

  expect_failures = [var.server_side_encryption]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid object_ownership is rejected.
# ---------------------------------------------------------------------------
run "invalid_object_ownership_rejected" {
  command = plan

  variables {
    object_ownership = "InvalidOwnership"
  }

  expect_failures = [var.object_ownership]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid aws_region is rejected.
# ---------------------------------------------------------------------------
run "invalid_aws_region_rejected" {
  command = plan

  variables {
    aws_region = "not-a-region"
  }

  expect_failures = [var.aws_region]
}
