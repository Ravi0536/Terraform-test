# Tests for the DynamoDB table adoption bundle.
# All tests run in plan mode -- no real AWS credentials are required.

variables {
  aws_region = "us-east-1"

  table_config = {
    name         = "tos-jira-dynamo-test"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"

    attributes = [
      {
        name = "id"
        type = "S"
      }
    ]

    point_in_time_recovery_enabled = true
    deletion_protection_enabled    = false
    table_class                    = null
    stream_enabled                 = false
    stream_view_type               = null
  }
}

# ---------------------------------------------------------------------------
# Plan-time structural invariants
# ---------------------------------------------------------------------------

run "table_name_matches_import_id" {
  command = plan

  assert {
    condition     = module.dynamodb_table.table_name == "tos-jira-dynamo-test"
    error_message = "Table name must match the import ID 'tos-jira-dynamo-test'."
  }
}

run "billing_mode_is_pay_per_request" {
  command = plan

  assert {
    condition     = module.dynamodb_table.billing_mode == "PAY_PER_REQUEST"
    error_message = "Billing mode must be PAY_PER_REQUEST to match the existing table."
  }
}

# ---------------------------------------------------------------------------
# Variable validation: invalid billing_mode is rejected
# ---------------------------------------------------------------------------

run "invalid_billing_mode_rejected" {
  command = plan

  variables {
    table_config = {
      name         = "tos-jira-dynamo-test"
      billing_mode = "INVALID"
      hash_key     = "id"

      attributes = [
        {
          name = "id"
          type = "S"
        }
      ]

      point_in_time_recovery_enabled = true
    }
  }

  expect_failures = [var.table_config]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid attribute type is rejected
# ---------------------------------------------------------------------------

run "invalid_attribute_type_rejected" {
  command = plan

  variables {
    table_config = {
      name         = "tos-jira-dynamo-test"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "id"

      attributes = [
        {
          name = "id"
          type = "X"
        }
      ]

      point_in_time_recovery_enabled = true
    }
  }

  expect_failures = [var.table_config]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid aws_region is rejected
# ---------------------------------------------------------------------------

run "invalid_aws_region_rejected" {
  command = plan

  variables {
    aws_region = "not-a-region"
  }

  expect_failures = [var.aws_region]
}

# ---------------------------------------------------------------------------
# Variable validation: stream_enabled=true without stream_view_type is rejected
# ---------------------------------------------------------------------------

run "stream_enabled_without_view_type_rejected" {
  command = plan

  variables {
    table_config = {
      name         = "tos-jira-dynamo-test"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "id"

      attributes = [
        {
          name = "id"
          type = "S"
        }
      ]

      point_in_time_recovery_enabled = true
      stream_enabled                 = true
      stream_view_type               = null
    }
  }

  expect_failures = [var.table_config]
}

# ---------------------------------------------------------------------------
# Variable validation: valid stream configuration is accepted
# ---------------------------------------------------------------------------

run "valid_stream_config_accepted" {
  command = plan

  variables {
    table_config = {
      name         = "tos-jira-dynamo-test"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "id"

      attributes = [
        {
          name = "id"
          type = "S"
        }
      ]

      point_in_time_recovery_enabled = true
      stream_enabled                 = true
      stream_view_type               = "NEW_AND_OLD_IMAGES"
    }
  }
}

# ---------------------------------------------------------------------------
# Variable validation: invalid table_class is rejected
# ---------------------------------------------------------------------------

run "invalid_table_class_rejected" {
  command = plan

  variables {
    table_config = {
      name         = "tos-jira-dynamo-test"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "id"

      attributes = [
        {
          name = "id"
          type = "S"
        }
      ]

      point_in_time_recovery_enabled = true
      table_class                    = "GLACIER"
    }
  }

  expect_failures = [var.table_config]
}
