resource "aws_sns_topic" "delivery_naming_proof" {
  name = var.sns_topic_config.name

  # Display
  display_name = var.sns_topic_config.display_name

  # FIFO settings
  fifo_topic                  = var.sns_topic_config.fifo_topic
  content_based_deduplication = var.sns_topic_config.content_based_deduplication
  fifo_throughput_scope       = var.sns_topic_config.fifo_throughput_scope
  archive_policy              = var.sns_topic_config.archive_policy

  # Policies
  policy          = var.sns_topic_config.policy
  delivery_policy = var.sns_topic_config.delivery_policy

  # Encryption
  kms_master_key_id = var.sns_topic_config.kms_master_key_id

  # Signing & tracing
  signature_version = var.sns_topic_config.signature_version
  tracing_config    = var.sns_topic_config.tracing_config

  # Delivery status feedback – Application
  application_success_feedback_role_arn    = var.sns_topic_config.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.sns_topic_config.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.sns_topic_config.application_failure_feedback_role_arn

  # Delivery status feedback – HTTP
  http_success_feedback_role_arn    = var.sns_topic_config.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.sns_topic_config.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.sns_topic_config.http_failure_feedback_role_arn

  # Delivery status feedback – Lambda
  lambda_success_feedback_role_arn    = var.sns_topic_config.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.sns_topic_config.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.sns_topic_config.lambda_failure_feedback_role_arn

  # Delivery status feedback – SQS
  sqs_success_feedback_role_arn    = var.sns_topic_config.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sns_topic_config.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.sns_topic_config.sqs_failure_feedback_role_arn

  # Delivery status feedback – Firehose
  firehose_success_feedback_role_arn    = var.sns_topic_config.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.sns_topic_config.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.sns_topic_config.firehose_failure_feedback_role_arn
}
