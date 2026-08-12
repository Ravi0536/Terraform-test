###############################################################################
# Unit tests (plan mode – no credentials required)
###############################################################################

# ---------------------------------------------------------------------------
# Test: standard (non-FIFO) topic with minimal config
# ---------------------------------------------------------------------------
run "standard_topic_creates" {
  command = plan

  variables {
    topic_config = {
      name = "vendor-naming-proof"
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.name == "vendor-naming-proof"
    error_message = "Expected topic name to be 'vendor-naming-proof'."
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.fifo_topic == false
    error_message = "Expected fifo_topic to be false for a standard topic."
  }
}

# ---------------------------------------------------------------------------
# Test: FIFO topic name must end with .fifo
# ---------------------------------------------------------------------------
run "fifo_topic_name_suffix" {
  command = plan

  variables {
    topic_config = {
      name       = "my-events.fifo"
      fifo_topic = true
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.fifo_topic == true
    error_message = "Expected fifo_topic to be true."
  }

  assert {
    condition     = endswith(aws_sns_topic.vendor_naming_proof.name, ".fifo")
    error_message = "FIFO topic name must end with '.fifo'."
  }
}

# ---------------------------------------------------------------------------
# Test: tracing_config PassThrough value accepted
# ---------------------------------------------------------------------------
run "tracing_config_passthrough" {
  command = plan

  variables {
    topic_config = {
      name           = "vendor-naming-proof"
      tracing_config = "PassThrough"
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.tracing_config == "PassThrough"
    error_message = "Expected tracing_config to be 'PassThrough'."
  }
}

# ---------------------------------------------------------------------------
# Test: tracing_config Active value accepted
# ---------------------------------------------------------------------------
run "tracing_config_active" {
  command = plan

  variables {
    topic_config = {
      name           = "vendor-naming-proof"
      tracing_config = "Active"
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.tracing_config == "Active"
    error_message = "Expected tracing_config to be 'Active'."
  }
}

# ---------------------------------------------------------------------------
# Test: signature_version 1 accepted
# ---------------------------------------------------------------------------
run "signature_version_1" {
  command = plan

  variables {
    topic_config = {
      name              = "vendor-naming-proof"
      signature_version = 1
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.signature_version == 1
    error_message = "Expected signature_version to be 1."
  }
}

# ---------------------------------------------------------------------------
# Test: signature_version 2 accepted
# ---------------------------------------------------------------------------
run "signature_version_2" {
  command = plan

  variables {
    topic_config = {
      name              = "vendor-naming-proof"
      signature_version = 2
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.signature_version == 2
    error_message = "Expected signature_version to be 2."
  }
}

# ---------------------------------------------------------------------------
# Test: kms encryption attribute flows through
# ---------------------------------------------------------------------------
run "kms_encryption" {
  command = plan

  variables {
    topic_config = {
      name              = "vendor-naming-proof"
      kms_master_key_id = "alias/aws/sns"
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.kms_master_key_id == "alias/aws/sns"
    error_message = "Expected kms_master_key_id to be 'alias/aws/sns'."
  }
}

# ---------------------------------------------------------------------------
# Test: display_name flows through
# ---------------------------------------------------------------------------
run "display_name" {
  command = plan

  variables {
    topic_config = {
      name         = "vendor-naming-proof"
      display_name = "Vendor Naming Proof"
    }
  }

  assert {
    condition     = aws_sns_topic.vendor_naming_proof.display_name == "Vendor Naming Proof"
    error_message = "Expected display_name to be 'Vendor Naming Proof'."
  }
}

# ---------------------------------------------------------------------------
# Variable validation: invalid tracing_config rejected
# ---------------------------------------------------------------------------
run "invalid_tracing_config_rejected" {
  command = plan

  variables {
    topic_config = {
      name           = "vendor-naming-proof"
      tracing_config = "Invalid"
    }
  }

  expect_failures = [var.topic_config]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid signature_version rejected
# ---------------------------------------------------------------------------
run "invalid_signature_version_rejected" {
  command = plan

  variables {
    topic_config = {
      name              = "vendor-naming-proof"
      signature_version = 3
    }
  }

  expect_failures = [var.topic_config]
}

# ---------------------------------------------------------------------------
# Variable validation: fifo_topic true but name missing .fifo suffix rejected
# ---------------------------------------------------------------------------
run "fifo_topic_missing_suffix_rejected" {
  command = plan

  variables {
    topic_config = {
      name       = "my-events"
      fifo_topic = true
    }
  }

  expect_failures = [var.topic_config]
}

# ---------------------------------------------------------------------------
# Variable validation: content_based_deduplication without fifo_topic rejected
# ---------------------------------------------------------------------------
run "dedup_without_fifo_rejected" {
  command = plan

  variables {
    topic_config = {
      name                        = "vendor-naming-proof"
      fifo_topic                  = false
      content_based_deduplication = true
    }
  }

  expect_failures = [var.topic_config]
}

# ---------------------------------------------------------------------------
# Variable validation: invalid fifo_throughput_scope rejected
# ---------------------------------------------------------------------------
run "invalid_fifo_throughput_scope_rejected" {
  command = plan

  variables {
    topic_config = {
      name                  = "my-events.fifo"
      fifo_topic            = true
      fifo_throughput_scope = "Invalid"
    }
  }

  expect_failures = [var.topic_config]
}

# ---------------------------------------------------------------------------
# Variable validation: sample rate > 100 rejected
# ---------------------------------------------------------------------------
run "sample_rate_out_of_range_rejected" {
  command = plan

  variables {
    topic_config = {
      name                              = "vendor-naming-proof"
      http_success_feedback_sample_rate = 101
      http_success_feedback_role_arn    = "arn:aws:iam::123456789012:role/sns-feedback"
    }
  }

  expect_failures = [var.topic_config]
}
