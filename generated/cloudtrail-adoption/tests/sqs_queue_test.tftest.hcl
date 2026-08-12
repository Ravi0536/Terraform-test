# Validate variable constraints — no credentials required (plan mode).

# ---------------------------------------------------------------------------
# Test: valid standard queue configuration (baseline)
# ---------------------------------------------------------------------------
run "valid_standard_queue" {
  command = plan

  variables {
    queue_name                 = "tos-extensibility-proof"
    aws_region                 = "us-east-1"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    fifo_queue                 = false
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.name == "tos-extensibility-proof"
    error_message = "Queue name must be 'tos-extensibility-proof'."
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.fifo_queue == false
    error_message = "Queue must be a standard (non-FIFO) queue."
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.delay_seconds == 0
    error_message = "delay_seconds must default to 0."
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.visibility_timeout_seconds == 30
    error_message = "visibility_timeout_seconds must default to 30."
  }
}

# ---------------------------------------------------------------------------
# Test: delay_seconds boundary — maximum allowed value
# ---------------------------------------------------------------------------
run "delay_seconds_max_boundary" {
  command = plan

  variables {
    queue_name    = "tos-extensibility-proof"
    delay_seconds = 900
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.delay_seconds == 900
    error_message = "delay_seconds should accept the maximum value of 900."
  }
}

# ---------------------------------------------------------------------------
# Test: message_retention_seconds boundary — minimum allowed value
# ---------------------------------------------------------------------------
run "message_retention_minimum" {
  command = plan

  variables {
    queue_name                = "tos-extensibility-proof"
    message_retention_seconds = 60
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.message_retention_seconds == 60
    error_message = "message_retention_seconds should accept the minimum value of 60."
  }
}

# ---------------------------------------------------------------------------
# Test: long-polling — maximum receive_wait_time_seconds
# ---------------------------------------------------------------------------
run "long_polling_max" {
  command = plan

  variables {
    queue_name                = "tos-extensibility-proof"
    receive_wait_time_seconds = 20
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.receive_wait_time_seconds == 20
    error_message = "receive_wait_time_seconds should accept the maximum value of 20."
  }
}

# ---------------------------------------------------------------------------
# Test: FIFO queue configuration
# ---------------------------------------------------------------------------
run "fifo_queue_configuration" {
  command = plan

  variables {
    queue_name                  = "tos-extensibility-proof.fifo"
    fifo_queue                  = true
    content_based_deduplication = true
    deduplication_scope         = "messageGroup"
    fifo_throughput_limit       = "perMessageGroupId"
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.fifo_queue == true
    error_message = "fifo_queue must be true."
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.content_based_deduplication == true
    error_message = "content_based_deduplication must be true."
  }
}

# ---------------------------------------------------------------------------
# Test: visibility_timeout maximum boundary
# ---------------------------------------------------------------------------
run "visibility_timeout_max" {
  command = plan

  variables {
    queue_name                 = "tos-extensibility-proof"
    visibility_timeout_seconds = 43200
  }

  assert {
    condition     = aws_sqs_queue.tos_extensibility_proof.visibility_timeout_seconds == 43200
    error_message = "visibility_timeout_seconds should accept the maximum value of 43200."
  }
}
