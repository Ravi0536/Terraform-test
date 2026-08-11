variables {
  aws_region   = "us-east-1"
  table_name   = "tos-mod-e2e-orders4"
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
# Variable validation: billing_mode must be PROVISIONED or PAY_PER_REQUEST
# ---------------------------------------------------------------------------
run "billing_mode_invalid_rejected" {
  command = plan

  variables {
    billing_mode = "ON_DEMAND"
  }

  expect_failures = [var.billing_mode]
}

# ---------------------------------------------------------------------------
# Variable validation: table_name too short
# ---------------------------------------------------------------------------
run "table_name_too_short_rejected" {
  command = plan

  variables {
    table_name = "ab"
  }

  expect_failures = [var.table_name]
}

# ---------------------------------------------------------------------------
# Variable validation: attribute type must be S/N/B
# ---------------------------------------------------------------------------
run "attribute_type_invalid_rejected" {
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
# Variable validation: aws_region format check
# ---------------------------------------------------------------------------
run "region_invalid_rejected" {
  command = plan

  variables {
    aws_region = "not-a-region"
  }

  expect_failures = [var.aws_region]
}

# ---------------------------------------------------------------------------
# Plan-time invariants: happy-path plan succeeds and resources look correct
# ---------------------------------------------------------------------------
run "happy_path_plan" {
  command = plan

  assert {
    condition     = module.aws_dynamodb_table.name == "tos-mod-e2e-orders4"
    error_message = "Expected table name tos-mod-e2e-orders4."
  }
}
