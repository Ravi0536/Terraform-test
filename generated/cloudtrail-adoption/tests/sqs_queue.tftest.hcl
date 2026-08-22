# Terraform native tests for the SQS queue bundle.
# All run blocks use plan mode so no AWS credentials are required.

# ---------------------------------------------------------------------------
# Variable validation tests
# ---------------------------------------------------------------------------

run "queue_name_valid" {
  command = plan

  variables {
    queue_name = "tos-lane-jira-0821234621"
    tags = {
      lane_run   = "0821234621"
      managed_by = "tos"
    }
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.name == "tos-lane-jira-0821234621"
    error_message = "Queue name must match the supplied variable."
  }
}

run "queue_name_empty_rejected" {
  command = plan

  variables {
    queue_name = ""
    tags       = {}
  }

  expect_failures = [var.queue_name]
}

run "queue_name_too_long_rejected" {
  command = plan

  # 81-character name exceeds the AWS limit of 80
  variables {
    queue_name = "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffff0123456789012345678"
    tags       = {}
  }

  expect_failures = [var.queue_name]
}

run "delay_seconds_out_of_range" {
  command = plan

  variables {
    queue_name    = "valid-queue"
    delay_seconds = 901
    tags          = {}
  }

  expect_failures = [var.delay_seconds]
}

run "max_message_size_too_small" {
  command = plan

  variables {
    queue_name       = "valid-queue"
    max_message_size = 512
    tags             = {}
  }

  expect_failures = [var.max_message_size]
}

run "message_retention_too_short" {
  command = plan

  variables {
    queue_name                = "valid-queue"
    message_retention_seconds = 30
    tags                      = {}
  }

  expect_failures = [var.message_retention_seconds]
}

run "receive_wait_time_out_of_range" {
  command = plan

  variables {
    queue_name                = "valid-queue"
    receive_wait_time_seconds = 21
    tags                      = {}
  }

  expect_failures = [var.receive_wait_time_seconds]
}

run "visibility_timeout_out_of_range" {
  command = plan

  variables {
    queue_name                 = "valid-queue"
    visibility_timeout_seconds = 43201
    tags                       = {}
  }

  expect_failures = [var.visibility_timeout_seconds]
}

run "invalid_deduplication_scope" {
  command = plan

  variables {
    queue_name          = "valid-queue.fifo"
    fifo_queue          = true
    deduplication_scope = "invalid"
    tags                = {}
  }

  expect_failures = [var.deduplication_scope]
}

run "invalid_fifo_throughput_limit" {
  command = plan

  variables {
    queue_name            = "valid-queue.fifo"
    fifo_queue            = true
    fifo_throughput_limit = "badValue"
    tags                  = {}
  }

  expect_failures = [var.fifo_throughput_limit]
}

run "kms_data_key_reuse_too_small" {
  command = plan

  variables {
    queue_name                        = "valid-queue"
    kms_master_key_id                 = "alias/aws/sqs"
    kms_data_key_reuse_period_seconds = 30
    tags                              = {}
  }

  expect_failures = [var.kms_data_key_reuse_period_seconds]
}

# ---------------------------------------------------------------------------
# Plan-time invariant: tags propagate correctly
# ---------------------------------------------------------------------------

run "tags_propagate_to_resource" {
  command = plan

  variables {
    queue_name = "tos-lane-jira-0821234621"
    tags = {
      lane_run   = "0821234621"
      managed_by = "tos"
    }
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.tags["lane_run"] == "0821234621"
    error_message = "lane_run tag must equal '0821234621'."
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.tags["managed_by"] == "tos"
    error_message = "managed_by tag must equal 'tos'."
  }
}

# ---------------------------------------------------------------------------
# Plan-time invariant: standard queue defaults
# ---------------------------------------------------------------------------

run "standard_queue_defaults" {
  command = plan

  variables {
    queue_name = "tos-lane-jira-0821234621"
    tags       = {}
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.fifo_queue == false
    error_message = "fifo_queue must default to false for a standard queue."
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.delay_seconds == 0
    error_message = "delay_seconds must default to 0."
  }

  assert {
    condition     = aws_sqs_queue.tos_lane_jira_0821234621.visibility_timeout_seconds == 30
    error_message = "visibility_timeout_seconds must default to 30."
  }
}
