variables {
  topic_name = "delivery-naming-proof"
  aws_region = "us-east-1"
}

# ── Variable validation: topic_name ───────────────────────────────────────────

run "valid_topic_name_accepted" {
  command = plan

  variables {
    topic_name = "my-valid-topic_name"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "my-valid-topic_name"
    error_message = "Expected topic name to equal the variable value."
  }
}

run "valid_fifo_topic_name_accepted" {
  command = plan

  variables {
    topic_name = "my-fifo-topic.fifo"
    fifo_topic = true
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "my-fifo-topic.fifo"
    error_message = "Expected FIFO topic name ending with '.fifo' to be accepted."
  }
}

run "invalid_topic_name_rejected" {
  command = plan

  variables {
    topic_name = "invalid name with spaces!"
  }

  expect_failures = [var.topic_name]
}

# ── Variable validation: aws_region ───────────────────────────────────────────

run "valid_region_accepted" {
  command = plan

  variables {
    aws_region = "eu-west-1"
  }

  assert {
    condition     = var.aws_region == "eu-west-1"
    error_message = "Expected eu-west-1 to be accepted as a valid region."
  }
}

run "invalid_region_rejected" {
  command = plan

  variables {
    aws_region = "not-a-region"
  }

  expect_failures = [var.aws_region]
}

# ── Variable validation: tracing_config ───────────────────────────────────────

run "valid_tracing_config_active" {
  command = plan

  variables {
    tracing_config = "Active"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.tracing_config == "Active"
    error_message = "Expected tracing_config 'Active' to be accepted."
  }
}

run "valid_tracing_config_passthrough" {
  command = plan

  variables {
    tracing_config = "PassThrough"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.tracing_config == "PassThrough"
    error_message = "Expected tracing_config 'PassThrough' to be accepted."
  }
}

run "invalid_tracing_config_rejected" {
  command = plan

  variables {
    tracing_config = "InvalidValue"
  }

  expect_failures = [var.tracing_config]
}

# ── Variable validation: signature_version ────────────────────────────────────

run "valid_signature_version_1" {
  command = plan

  variables {
    signature_version = 1
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.signature_version == 1
    error_message = "Expected signature_version 1 (SHA1) to be accepted."
  }
}

run "valid_signature_version_2" {
  command = plan

  variables {
    signature_version = 2
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.signature_version == 2
    error_message = "Expected signature_version 2 (SHA256) to be accepted."
  }
}

run "invalid_signature_version_rejected" {
  command = plan

  variables {
    signature_version = 3
  }

  expect_failures = [var.signature_version]
}

# ── Variable validation: feedback sample rates ────────────────────────────────

run "valid_sample_rate_boundary_zero" {
  command = plan

  variables {
    http_success_feedback_sample_rate = 0
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.http_success_feedback_sample_rate == 0
    error_message = "Expected sample rate of 0 to be accepted."
  }
}

run "valid_sample_rate_boundary_hundred" {
  command = plan

  variables {
    sqs_success_feedback_sample_rate = 100
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.sqs_success_feedback_sample_rate == 100
    error_message = "Expected sample rate of 100 to be accepted."
  }
}

run "invalid_sample_rate_over_100_rejected" {
  command = plan

  variables {
    lambda_success_feedback_sample_rate = 101
  }

  expect_failures = [var.lambda_success_feedback_sample_rate]
}

run "invalid_sample_rate_negative_rejected" {
  command = plan

  variables {
    firehose_success_feedback_sample_rate = -1
  }

  expect_failures = [var.firehose_success_feedback_sample_rate]
}

# ── Variable validation: fifo_throughput_scope ────────────────────────────────

run "valid_fifo_throughput_scope_topic" {
  command = plan

  variables {
    topic_name            = "scoped-topic.fifo"
    fifo_topic            = true
    fifo_throughput_scope = "Topic"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.fifo_throughput_scope == "Topic"
    error_message = "Expected fifo_throughput_scope 'Topic' to be accepted."
  }
}

run "invalid_fifo_throughput_scope_rejected" {
  command = plan

  variables {
    fifo_throughput_scope = "InvalidScope"
  }

  expect_failures = [var.fifo_throughput_scope]
}

# ── Plan invariants ───────────────────────────────────────────────────────────

run "topic_name_propagates_to_resource" {
  command = plan

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "delivery-naming-proof"
    error_message = "Topic name must match the topic_name variable."
  }
}

run "fifo_defaults_to_false" {
  command = plan

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.fifo_topic == false
    error_message = "fifo_topic must default to false for standard topics."
  }
}

run "content_based_dedup_defaults_to_false" {
  command = plan

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.content_based_deduplication == false
    error_message = "content_based_deduplication must default to false."
  }
}
