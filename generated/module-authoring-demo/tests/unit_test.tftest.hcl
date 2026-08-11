# Unit tests for the DynamoDB table bundle — plan-mode only, no credentials needed.

variables {
  region       = "us-east-1"
  table_name   = "tos-mod-e2e-orders5"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
  tags = {
    env        = "test"
    managed-by = "tos-e2e"
  }
}

# ---------------------------------------------------------------------------
# Variable validation: billing_mode
# ---------------------------------------------------------------------------
run "invalid_billing_mode_rejected" {
  command = plan

  variables {
    billing_mode = "UNKNOWN"
  }

  expect_failures = [var.billing_mode]
}

# ---------------------------------------------------------------------------
# Variable validation: region format
# ---------------------------------------------------------------------------
run "invalid_region_rejected" {
  command = plan

  variables {
    region = "notaregion"
  }

  expect_failures = [var.region]
}

# ---------------------------------------------------------------------------
# Variable validation: table_name length (too short)
# ---------------------------------------------------------------------------
run "table_name_too_short_rejected" {
  command = plan

  variables {
    table_name = "ab"
  }

  expect_failures = [var.table_name]
}

# ---------------------------------------------------------------------------
# Variable validation: attribute type must be S, N, or B
# ---------------------------------------------------------------------------
run "invalid_attribute_type_rejected" {
  command = plan

  variables {
    attributes = [
      {
        name = "id"
        type = "X"
      }
    ]
  }

  expect_failures = [var.attributes]
}

# ---------------------------------------------------------------------------
# Variable validation: table_class must be valid
# ---------------------------------------------------------------------------
run "invalid_table_class_rejected" {
  command = plan

  variables {
    table_class = "CHEAP"
  }

  expect_failures = [var.table_class]
}

# ---------------------------------------------------------------------------
# Variable validation: stream_view_type must be valid
# ---------------------------------------------------------------------------
run "invalid_stream_view_type_rejected" {
  command = plan

  variables {
    stream_view_type = "ALL"
  }

  expect_failures = [var.stream_view_type]
}

# ---------------------------------------------------------------------------
# Happy-path plan: PAY_PER_REQUEST table with required variables
# ---------------------------------------------------------------------------
run "plan_creates_table" {
  command = plan

  assert {
    condition     = module.aws_dynamodb_table.aws_dynamodb_table.this.name == "tos-mod-e2e-orders5"
    error_message = "Expected table name to be tos-mod-e2e-orders5."
  }

  assert {
    condition     = module.aws_dynamodb_table.aws_dynamodb_table.this.billing_mode == "PAY_PER_REQUEST"
    error_message = "Expected billing_mode to be PAY_PER_REQUEST."
  }

  assert {
    condition     = module.aws_dynamodb_table.aws_dynamodb_table.this.hash_key == "id"
    error_message = "Expected hash_key to be id."
  }
}

# ---------------------------------------------------------------------------
# PITR enabled plan
# ---------------------------------------------------------------------------
run "plan_with_pitr_enabled" {
  command = plan

  variables {
    point_in_time_recovery_enabled = true
  }

  assert {
    condition     = module.aws_dynamodb_table.aws_dynamodb_table.this.point_in_time_recovery[0].enabled == true
    error_message = "Expected point_in_time_recovery to be enabled."
  }
}

# ---------------------------------------------------------------------------
# Streams enabled plan
# ---------------------------------------------------------------------------
run "plan_with_streams_enabled" {
  command = plan

  variables {
    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
  }

  assert {
    condition     = module.aws_dynamodb_table.aws_dynamodb_table.this.stream_enabled == true
    error_message = "Expected stream_enabled to be true."
  }
}
