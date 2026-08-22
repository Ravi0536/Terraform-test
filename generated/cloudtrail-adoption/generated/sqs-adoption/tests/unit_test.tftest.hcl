# Unit tests for the sqs-adoption root configuration.
# All run blocks use plan mode – no AWS credentials required.

variables {
  queue_config = {
    name                      = "tos-jira-agentic-e2e"
    message_retention_seconds = 1209600
    sqs_managed_sse_enabled   = true
  }
  tags = {
    lane_drift_probe = "0822b"
  }
}

# ---------------------------------------------------------------------------
# 1. Happy-path: default configuration plans without error.
# ---------------------------------------------------------------------------
run "valid_default_config" {
  command = plan

  assert {
    condition     = module.sqs_queue.queue_name == "tos-jira-agentic-e2e"
    error_message = "Expected queue name to be 'tos-jira-agentic-e2e'."
  }
}

# ---------------------------------------------------------------------------
# 2. Retention at minimum boundary (60 seconds) is accepted.
# ---------------------------------------------------------------------------
run "retention_at_minimum_boundary" {
  command = plan

  variables {
    queue_config = {
      name                      = "tos-jira-agentic-e2e"
      message_retention_seconds = 60
      sqs_managed_sse_enabled   = true
    }
  }

  assert {
    condition     = module.sqs_queue.queue_name == "tos-jira-agentic-e2e"
    error_message = "Queue should be valid with message_retention_seconds = 60."
  }
}

# ---------------------------------------------------------------------------
# 3. Retention at maximum boundary (1209600 seconds / 14 days) is accepted.
# ---------------------------------------------------------------------------
run "retention_at_maximum_boundary" {
  command = plan

  variables {
    queue_config = {
      name                      = "tos-jira-agentic-e2e"
      message_retention_seconds = 1209600
      sqs_managed_sse_enabled   = true
    }
  }

  assert {
    condition     = module.sqs_queue.queue_name == "tos-jira-agentic-e2e"
    error_message = "Queue should be valid with message_retention_seconds = 1209600."
  }
}

# ---------------------------------------------------------------------------
# 4. SSE can be disabled.
# ---------------------------------------------------------------------------
run "sse_disabled" {
  command = plan

  variables {
    queue_config = {
      name                      = "tos-jira-agentic-e2e"
      message_retention_seconds = 345600
      sqs_managed_sse_enabled   = false
    }
  }

  assert {
    condition     = module.sqs_queue.queue_name == "tos-jira-agentic-e2e"
    error_message = "Queue should be valid with sqs_managed_sse_enabled = false."
  }
}
