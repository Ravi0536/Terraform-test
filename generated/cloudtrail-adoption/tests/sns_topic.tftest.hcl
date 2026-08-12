# ── Variable validation tests (plan mode — no credentials required) ──────────

# Default: valid standard topic name
run "valid_standard_topic_name" {
  command = plan

  variables {
    topic_name = "append-proof"
  }

  assert {
    condition     = aws_sns_topic.append_proof.name == "append-proof"
    error_message = "Expected topic name to equal 'append-proof'."
  }
}

# FIFO topic with .fifo suffix
run "valid_fifo_topic_name" {
  command = plan

  variables {
    topic_name                  = "append-proof.fifo"
    fifo_topic                  = true
    content_based_deduplication = true
  }

  assert {
    condition     = aws_sns_topic.append_proof.fifo_topic == true
    error_message = "Expected fifo_topic to be true."
  }

  assert {
    condition     = aws_sns_topic.append_proof.content_based_deduplication == true
    error_message = "Expected content_based_deduplication to be true."
  }
}

# Tracing config — PassThrough
run "valid_tracing_passthrough" {
  command = plan

  variables {
    topic_name     = "append-proof"
    tracing_config = "PassThrough"
  }

  assert {
    condition     = aws_sns_topic.append_proof.tracing_config == "PassThrough"
    error_message = "Expected tracing_config to be 'PassThrough'."
  }
}

# Tracing config — Active
run "valid_tracing_active" {
  command = plan

  variables {
    topic_name     = "append-proof"
    tracing_config = "Active"
  }

  assert {
    condition     = aws_sns_topic.append_proof.tracing_config == "Active"
    error_message = "Expected tracing_config to be 'Active'."
  }
}

# Signature version 2 (SHA256)
run "valid_signature_version_2" {
  command = plan

  variables {
    topic_name        = "append-proof"
    signature_version = 2
  }

  assert {
    condition     = aws_sns_topic.append_proof.signature_version == 2
    error_message = "Expected signature_version to be 2."
  }
}

# Tags are forwarded to the resource
run "tags_are_set" {
  command = plan

  variables {
    topic_name = "append-proof"
    tags = {
      Environment = "test"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = aws_sns_topic.append_proof.tags["Environment"] == "test"
    error_message = "Expected tag 'Environment' to equal 'test'."
  }
}

# display_name is forwarded
run "display_name_is_set" {
  command = plan

  variables {
    topic_name   = "append-proof"
    display_name = "Append Proof Notifications"
  }

  assert {
    condition     = aws_sns_topic.append_proof.display_name == "Append Proof Notifications"
    error_message = "Expected display_name to equal 'Append Proof Notifications'."
  }
}

# FIFO throughput scope MessageGroup
run "valid_fifo_throughput_scope_message_group" {
  command = plan

  variables {
    topic_name            = "append-proof.fifo"
    fifo_topic            = true
    fifo_throughput_scope = "MessageGroup"
  }

  assert {
    condition     = aws_sns_topic.append_proof.fifo_throughput_scope == "MessageGroup"
    error_message = "Expected fifo_throughput_scope to be 'MessageGroup'."
  }
}

# Feedback sample rate boundary — 0
run "feedback_sample_rate_zero" {
  command = plan

  variables {
    topic_name                        = "append-proof"
    http_success_feedback_role_arn    = "arn:aws:iam::346589946607:role/sns-feedback"
    http_success_feedback_sample_rate = 0
    http_failure_feedback_role_arn    = "arn:aws:iam::346589946607:role/sns-feedback"
  }

  assert {
    condition     = aws_sns_topic.append_proof.http_success_feedback_sample_rate == 0
    error_message = "Expected http_success_feedback_sample_rate to be 0."
  }
}

# Feedback sample rate boundary — 100
run "feedback_sample_rate_hundred" {
  command = plan

  variables {
    topic_name                       = "append-proof"
    sqs_success_feedback_role_arn    = "arn:aws:iam::346589946607:role/sns-feedback"
    sqs_success_feedback_sample_rate = 100
    sqs_failure_feedback_role_arn    = "arn:aws:iam::346589946607:role/sns-feedback"
  }

  assert {
    condition     = aws_sns_topic.append_proof.sqs_success_feedback_sample_rate == 100
    error_message = "Expected sqs_success_feedback_sample_rate to be 100."
  }
}
