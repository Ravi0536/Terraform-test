run "validate_name_default" {
  command = plan

  assert {
    condition     = aws_sns_topic.service_file_proof.name == "service-file-proof"
    error_message = "SNS topic name should equal the default variable value."
  }
}

run "validate_name_override" {
  command = plan

  variables {
    name = "valid-topic-name"
  }

  assert {
    condition     = aws_sns_topic.service_file_proof.name == "valid-topic-name"
    error_message = "SNS topic name should equal the variable value."
  }
}

run "validate_fifo_topic_settings" {
  command = plan

  variables {
    name                        = "my-fifo-topic.fifo"
    fifo_topic                  = true
    content_based_deduplication = true
  }

  assert {
    condition     = aws_sns_topic.service_file_proof.fifo_topic == true
    error_message = "fifo_topic should be true when configured."
  }

  assert {
    condition     = aws_sns_topic.service_file_proof.content_based_deduplication == true
    error_message = "content_based_deduplication should be true when configured."
  }
}

run "validate_tracing_config_passthrough" {
  command = plan

  variables {
    name           = "tracing-topic"
    tracing_config = "PassThrough"
  }

  assert {
    condition     = aws_sns_topic.service_file_proof.tracing_config == "PassThrough"
    error_message = "tracing_config should be 'PassThrough' when configured."
  }
}

run "validate_encryption_key" {
  command = plan

  variables {
    name              = "encrypted-topic"
    kms_master_key_id = "alias/aws/sns"
  }

  assert {
    condition     = aws_sns_topic.service_file_proof.kms_master_key_id == "alias/aws/sns"
    error_message = "kms_master_key_id should equal the variable value."
  }
}
