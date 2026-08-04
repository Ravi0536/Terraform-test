# Unit tests for the iam_role module — plan mode only, no credentials required.

variables {
  name = "test-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

run "reject_empty_name" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [var.name]
}

run "reject_name_too_long" {
  command = plan

  variables {
    name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  expect_failures = [var.name]
}

run "reject_max_session_duration_too_short" {
  command = plan

  variables {
    max_session_duration = 1800
  }

  expect_failures = [var.max_session_duration]
}

run "reject_max_session_duration_too_long" {
  command = plan

  variables {
    max_session_duration = 99999
  }

  expect_failures = [var.max_session_duration]
}

run "plan_valid_role" {
  command = plan

  assert {
    condition     = aws_iam_role.main.name == "test-role"
    error_message = "IAM role name must match the input variable."
  }
}
