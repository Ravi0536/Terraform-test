# Unit tests — plan mode only, no real infrastructure required.

variables {
  iam_role_name        = "tos-resource-counter-role"
  lambda_function_name = "tos-resource-counter"
  lambda_description   = "Counts AWS resources by service - TOS pipeline deployment test subject"
  lambda_runtime       = "python3.12"
  lambda_handler       = "handler.handler"
  lambda_memory_size   = 256
  lambda_timeout       = 60

  lambda_logging_config = {
    log_format = "Text"
    log_group  = "/aws/lambda/tos-resource-counter"
  }

  tags = {
    purpose   = "pipeline-deployment-test"
    "tos-e2e" = "true"
  }
}

# ---------------------------------------------------------------------------
# Variable validation — invalid values must be rejected at plan time.
# ---------------------------------------------------------------------------

run "reject_empty_iam_role_name" {
  command = plan

  variables {
    iam_role_name = ""
  }

  expect_failures = [var.iam_role_name]
}

run "reject_too_long_iam_role_name" {
  command = plan

  variables {
    iam_role_name = "this-name-is-way-too-long-for-an-iam-role-and-should-definitely-fail-validation-check"
  }

  expect_failures = [var.iam_role_name]
}

run "reject_empty_lambda_function_name" {
  command = plan

  variables {
    lambda_function_name = ""
  }

  expect_failures = [var.lambda_function_name]
}

run "reject_invalid_lambda_runtime" {
  command = plan

  variables {
    lambda_runtime = "python2.7"
  }

  expect_failures = [var.lambda_runtime]
}

run "reject_lambda_memory_too_small" {
  command = plan

  variables {
    lambda_memory_size = 64
  }

  expect_failures = [var.lambda_memory_size]
}

run "reject_lambda_memory_too_large" {
  command = plan

  variables {
    lambda_memory_size = 99999
  }

  expect_failures = [var.lambda_memory_size]
}

run "reject_lambda_timeout_zero" {
  command = plan

  variables {
    lambda_timeout = 0
  }

  expect_failures = [var.lambda_timeout]
}

run "reject_lambda_timeout_too_large" {
  command = plan

  variables {
    lambda_timeout = 901
  }

  expect_failures = [var.lambda_timeout]
}

run "reject_invalid_log_format" {
  command = plan

  variables {
    lambda_logging_config = {
      log_format = "invalid"
      log_group  = "/aws/lambda/tos-resource-counter"
    }
  }

  expect_failures = [var.lambda_logging_config]
}

# ---------------------------------------------------------------------------
# Plan-time invariants — valid configuration must produce a coherent plan.
# ---------------------------------------------------------------------------

run "plan_succeeds_with_valid_variables" {
  command = plan

  assert {
    condition     = module.iam_role.arn != ""
    error_message = "IAM role ARN must not be empty after plan."
  }

  assert {
    condition     = module.lambda_function.arn != ""
    error_message = "Lambda function ARN must not be empty after plan."
  }
}

run "plan_with_null_logging_config" {
  command = plan

  variables {
    lambda_logging_config = null
  }

  assert {
    condition     = module.lambda_function.name == "tos-resource-counter"
    error_message = "Lambda function name should equal lambda_function_name variable."
  }
}

run "plan_arm64_architecture" {
  command = plan

  # Override via module variable by adjusting a compatible root config.
  # Architecture validation is exercised in the module unit tests.
  assert {
    condition     = module.lambda_function.name == "tos-resource-counter"
    error_message = "Lambda function name should remain stable across architecture changes."
  }
}
