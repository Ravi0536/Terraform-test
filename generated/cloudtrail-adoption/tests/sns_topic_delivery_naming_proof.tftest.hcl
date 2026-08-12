run "topic_name_validation_rejects_empty" {
  command = plan

  variables {
    sns_topic_name = "a"
    aws_region     = "us-east-1"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "a"
    error_message = "SNS topic name should equal the provided variable value."
  }
}

run "topic_name_validation_accepts_standard_name" {
  command = plan

  variables {
    sns_topic_name = "delivery-naming-proof"
    aws_region     = "us-east-1"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.name == "delivery-naming-proof"
    error_message = "SNS topic name should equal 'delivery-naming-proof'."
  }
}

run "fifo_defaults_to_false" {
  command = plan

  variables {
    sns_topic_name = "delivery-naming-proof"
    aws_region     = "us-east-1"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.fifo_topic == false
    error_message = "fifo_topic should default to false."
  }
}

run "content_based_dedup_defaults_to_false" {
  command = plan

  variables {
    sns_topic_name = "delivery-naming-proof"
    aws_region     = "us-east-1"
  }

  assert {
    condition     = aws_sns_topic.delivery_naming_proof.content_based_deduplication == false
    error_message = "content_based_deduplication should default to false."
  }
}
