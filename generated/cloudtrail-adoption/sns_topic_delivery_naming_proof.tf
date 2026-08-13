resource "aws_sns_topic" "delivery_naming_proof" {
  name = var.sns_topic_name

  display_name = var.display_name

  # Encryption
  kms_master_key_id = var.kms_master_key_id

  # Access policy
  policy = var.policy

  # Delivery policy
  delivery_policy = var.delivery_policy

  # Signature version (1 = SHA1, 2 = SHA256)
  signature_version = var.signature_version

  # Tracing
  tracing_config = var.tracing_config

  # FIFO settings
  fifo_topic                  = var.fifo_topic
  fifo_throughput_scope       = var.fifo_throughput_scope
  content_based_deduplication = var.content_based_deduplication
  archive_policy              = var.archive_policy

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
