# Tests for the dynamodb_table module and root configuration.
# All run blocks use plan mode -- no AWS credentials required.

variables {
  aws_region   = "us-east-1"
  table_name   = "tos-e2e-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"

  attributes = [
    { name = "created_at", type = "S" },
    { name = "customer_id", type = "S" },
    { name = "order_id", type = "S" },
  ]

  global_secondary_indexes = [
    {
      name            = "by-customer"
      hash_key        = "customer_id"
      range_key       = "created_at"
      projection_type = "ALL"
    },
  ]

  tags = {
    owner   = "ravindra.kande@gmail.com"
    purpose = "user-perspective-testing"
    tos-e2e = "true"
  }
}

# ---------------------------------------------------------------------------
# Plan-mode smoke test: all variables valid, configuration plans successfully.
# ---------------------------------------------------------------------------
run "valid_configuration_plans" {
  command = plan

  assert {
    condition     = module.orders_table.table_name == "tos-e2e-orders"
    error_message = "Expected table_name to be tos-e2e-orders."
  }
}

# ---------------------------------------------------------------------------
# Variable validation: invalid billing_mode must be rejected.
# ---------------------------------------------------------------------------
run "invalid_billing_mode_rejected" {
  command = plan

  variables {
    billing_mode = "ON_DEMAND"
  }

  expect_failures = [
    var.billing_mode,
  ]
}

# ---------------------------------------------------------------------------
# Variable validation: table_name too short must be rejected.
# ---------------------------------------------------------------------------
run "table_name_too_short_rejected" {
  command = plan

  variables {
    table_name = "ab"
  }

  expect_failures = [
    var.table_name,
  ]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid attribute type must be rejected.
# ---------------------------------------------------------------------------
run "invalid_attribute_type_rejected" {
  command = plan

  variables {
    attributes = [
      { name = "order_id", type = "X" },
    ]
  }

  expect_failures = [
    var.attributes,
  ]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid region format must be rejected.
# ---------------------------------------------------------------------------
run "invalid_region_rejected" {
  command = plan

  variables {
    aws_region = "not-a-region"
  }

  expect_failures = [
    var.aws_region,
  ]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid GSI projection_type must be rejected.
# ---------------------------------------------------------------------------
run "invalid_gsi_projection_type_rejected" {
  command = plan

  variables {
    global_secondary_indexes = [
      {
        name            = "bad-gsi"
        hash_key        = "customer_id"
        projection_type = "FULL"
      },
    ]
  }

  expect_failures = [
    var.global_secondary_indexes,
  ]
}

# ---------------------------------------------------------------------------
# Plan-time invariant: module output wires through correctly.
# ---------------------------------------------------------------------------
run "module_outputs_wired" {
  command = plan

  assert {
    condition     = module.orders_table.table_id == var.table_name
    error_message = "table_id output must equal the table name."
  }
}
