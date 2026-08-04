# Unit tests for the lambda_function module — plan mode only, no credentials required.

variables {
  function_name = "test-function"
  role_arn      = "arn:aws:iam::123456789012:role/test-role"
  runtime       = "python3.12"
  handler       = "handler.handler"
  memory_size   = 256
  timeout       = 60
}

run "reject_empty_function_name" {
  command = plan

  variables {
    function_name = ""
  }

  expect_failures = [var.function_name]
}

run "reject_invalid_runtime" {
  command = plan

  variables {
    runtime = "python2.7"
  }

  expect_failures = [var.runtime]
}

run "reject_memory_too_small" {
  command = plan

  variables {
    memory_size = 64
  }

  expect_failures = [var.memory_size]
}

run "reject_memory_too_large" {
  command = plan

  variables {
    memory_size = 40000
  }

  expect_failures = [var.memory_size]
}

run "reject_timeout_zero" {
  command = plan

  variables {
    timeout = 0
  }

  expect_failures = [var.timeout]
}

run "reject_timeout_over_limit" {
  command = plan

  variables {
    timeout = 901
  }

  expect_failures = [var.timeout]
}

run "reject_invalid_architecture" {
  command = plan

  variables {
    architectures = ["x86"]
  }

  expect_failures = [var.architectures]
}

run "reject_invalid_log_format" {
  command = plan

  variables {
    logging_config = {
      log_format = "INVALID"
      log_group  = "/aws/lambda/test"
    }
  }

  expect_failures = [var.logging_config]
}

run "plan_valid_function" {
  command = plan

  assert {
    condition     = aws_lambda_function.main.function_name == "test-function"
    error_message = "Lambda function name must match the input variable."
  }
}

run "plan_with_logging_config" {
  command = plan

  variables {
    logging_config = {
      log_format = "Text"
      log_group  = "/aws/lambda/test-function"
    }
  }

  assert {
    condition     = aws_lambda_function.main.function_name == "test-function"
    error_message = "Lambda function name must remain stable when logging_config is set."
  }
}
