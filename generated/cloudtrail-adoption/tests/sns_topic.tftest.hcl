variables {
  sns_topic_config = {
    name = "delivery-naming-proof"
  }
}

# ---------------------------------------------------------------------------
# Plan-mode unit tests – no credentials required
# ---------------------------------------------------------------------------

run "valid_standard_topic_plan" {
  command = plan

  variables {
    sns_topic_config = {
      name = "delivery-naming-proof"
    }
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "delivery-naming-proof"
    error_message = "SNS topic name must equal 'delivery-naming-proof'."
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.fifo_topic == false
    error_message = "Standard topic must not be a FIFO topic."
  }
}

run "valid_fifo_topic_plan" {
  command = plan

  variables {
    sns_topic_config = {
      name                        = "my-queue.fifo"
      fifo_topic                  = true
      content_based_deduplication = true
    }
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.fifo_topic == true
    error_message = "FIFO topic flag must be true when configured."
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.content_based_deduplication == true
    error_message = "content_based_deduplication must be true when configured."
  }
}

run "valid_tracing_config_passthrough_plan" {
  command = plan

  variables {
    sns_topic_config = {
      name           = "delivery-naming-proof"
      tracing_config = "PassThrough"
    }
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.tracing_config == "PassThrough"
    error_message = "tracing_config must be 'PassThrough'."
  }
}

run "valid_tracing_config_active_plan" {
  command = plan

  variables {
    sns_topic_config = {
      name           = "delivery-naming-proof"
      tracing_config = "Active"
    }
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.tracing_config == "Active"
    error_message = "tracing_config must be 'Active'."
  }
}

run "valid_signature_version_plan" {
  command = plan

  variables {
    sns_topic_config = {
      name              = "delivery-naming-proof"
      signature_version = 2
    }
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.signature_version == 2
    error_message = "signature_version must equal 2."
  }
}

# ---------------------------------------------------------------------------
# Variable validation tests
# ---------------------------------------------------------------------------

run "invalid_topic_name_rejects_empty" {
  command = plan

  variables {
    sns_topic_config = {
      name = ""
    }
  }

  expect_failures = [var.sns_topic_config]
}

run "invalid_topic_name_rejects_special_chars" {
  command = plan

  variables {
    sns_topic_config = {
      name = "bad name!"
    }
  }

  expect_failures = [var.sns_topic_config]
}

run "invalid_tracing_config_rejects_unknown" {
  command = plan

  variables {
    sns_topic_config = {
      name           = "delivery-naming-proof"
      tracing_config = "Unknown"
    }
  }

  expect_failures = [var.sns_topic_config]
}

run "invalid_signature_version_rejects_bad_value" {
  command = plan

  variables {
    sns_topic_config = {
      name              = "delivery-naming-proof"
      signature_version = 3
    }
  }

  expect_failures = [var.sns_topic_config]
}

run "invalid_sample_rate_rejects_out_of_range" {
  command = plan

  variables {
    sns_topic_config = {
      name                              = "delivery-naming-proof"
      http_success_feedback_sample_rate = 101
    }
  }

  expect_failures = [var.sns_topic_config]
}

run "invalid_region_rejects_bad_format" {
  command = plan

  variables {
    aws_region = "not-a-region"
    sns_topic_config = {
      name = "delivery-naming-proof"
    }
  }

  expect_failures = [var.aws_region]
}
