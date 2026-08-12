# Tests for aws_sns_topic.style_guide_proof
#
# All tests run in plan mode — no AWS credentials are required.

# ── Valid baseline ────────────────────────────────────────────────────────────

run "valid_standard_topic" {
  command = plan

  variables {
    name = "style-guide-proof"
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.name == "style-guide-proof"
    error_message = "Topic name should match the supplied variable."
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.fifo_topic == false
    error_message = "Standard topic must not be marked as FIFO."
  }
}

# ── FIFO topic ────────────────────────────────────────────────────────────────

run "valid_fifo_topic" {
  command = plan

  variables {
    name                        = "my-topic.fifo"
    fifo_topic                  = true
    content_based_deduplication = true
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.fifo_topic == true
    error_message = "fifo_topic attribute must be true for a FIFO topic."
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.content_based_deduplication == true
    error_message = "content_based_deduplication must be enabled as requested."
  }
}

# ── Encryption ────────────────────────────────────────────────────────────────

run "valid_kms_encrypted_topic" {
  command = plan

  variables {
    name              = "style-guide-proof"
    kms_master_key_id = "alias/aws/sns"
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.kms_master_key_id == "alias/aws/sns"
    error_message = "KMS master key ID must be set to the provided value."
  }
}

# ── Tracing config validation ─────────────────────────────────────────────────

run "valid_tracing_passthrough" {
  command = plan

  variables {
    name           = "style-guide-proof"
    tracing_config = "PassThrough"
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.tracing_config == "PassThrough"
    error_message = "tracing_config should be set to PassThrough."
  }
}

run "valid_tracing_active" {
  command = plan

  variables {
    name           = "style-guide-proof"
    tracing_config = "Active"
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.tracing_config == "Active"
    error_message = "tracing_config should be set to Active."
  }
}

# ── Signature version validation ──────────────────────────────────────────────

run "valid_signature_version_2" {
  command = plan

  variables {
    name              = "style-guide-proof"
    signature_version = 2
  }

  assert {
    condition     = aws_sns_topic.style_guide_proof.signature_version == 2
    error_message = "signature_version must be 2 when SHA256 is requested."
  }
}

# ── Variable validation: invalid tracing_config ───────────────────────────────

run "invalid_tracing_config_rejected" {
  command = plan

  variables {
    name           = "style-guide-proof"
    tracing_config = "InvalidValue"
  }

  expect_failures = [var.tracing_config]
}

# ── Variable validation: invalid signature_version ────────────────────────────

run "invalid_signature_version_rejected" {
  command = plan

  variables {
    name              = "style-guide-proof"
    signature_version = 99
  }

  expect_failures = [var.signature_version]
}

# ── Variable validation: invalid sample rate ──────────────────────────────────

run "invalid_http_sample_rate_rejected" {
  command = plan

  variables {
    name                              = "style-guide-proof"
    http_success_feedback_sample_rate = 150
  }

  expect_failures = [var.http_success_feedback_sample_rate]
}

# ── Variable validation: name length ──────────────────────────────────────────

run "invalid_empty_name_rejected" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [var.name]
}
