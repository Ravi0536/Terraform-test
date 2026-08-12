resource "aws_ecr_repository" "tos_dev_agentic" {
  name                 = "tos-dev-agentic"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    service     = "tos"
  }
}

import {
  to = aws_ecr_repository.tos_dev_agentic
  id = "tos-dev-agentic"
}

resource "aws_sns_topic" "style_guide_proof" {
  name = var.name

  display_name = var.display_name
  policy       = var.policy

  delivery_policy = var.delivery_policy
  archive_policy  = var.archive_policy

  fifo_topic                  = var.fifo_topic
  fifo_throughput_scope       = var.fifo_throughput_scope
  content_based_deduplication = var.content_based_deduplication

  kms_master_key_id = var.kms_master_key_id
  signature_version = var.signature_version
  tracing_config    = var.tracing_config

  # Application endpoint feedback
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn

  # HTTP endpoint feedback
  http_success_feedback_role_arn    = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.http_failure_feedback_role_arn

  # Lambda endpoint feedback
  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn

  # SQS endpoint feedback
  sqs_success_feedback_role_arn    = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.sqs_failure_feedback_role_arn

  # Firehose endpoint feedback
  firehose_success_feedback_role_arn    = var.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.firehose_failure_feedback_role_arn
}
