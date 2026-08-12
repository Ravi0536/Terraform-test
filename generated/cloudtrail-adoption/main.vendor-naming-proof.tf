resource "aws_sns_topic" "vendor_naming_proof" {
  name         = var.topic_config.name
  display_name = var.topic_config.display_name

  # Encryption
  kms_master_key_id = var.topic_config.kms_master_key_id

  # Policies
  policy          = var.topic_config.policy
  delivery_policy = var.topic_config.delivery_policy
  archive_policy  = var.topic_config.archive_policy

  # FIFO settings
  fifo_topic                  = var.topic_config.fifo_topic
  content_based_deduplication = var.topic_config.content_based_deduplication
  fifo_throughput_scope       = var.topic_config.fifo_throughput_scope

  # Observability
  tracing_config    = var.topic_config.tracing_config
  signature_version = var.topic_config.signature_version

  # Application endpoint feedback
  application_success_feedback_role_arn    = var.topic_config.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.topic_config.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.topic_config.application_failure_feedback_role_arn

  # HTTP endpoint feedback
  http_success_feedback_role_arn    = var.topic_config.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.topic_config.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.topic_config.http_failure_feedback_role_arn

  # Lambda endpoint feedback
  lambda_success_feedback_role_arn    = var.topic_config.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.topic_config.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.topic_config.lambda_failure_feedback_role_arn

  # SQS endpoint feedback
  sqs_success_feedback_role_arn    = var.topic_config.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.topic_config.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.topic_config.sqs_failure_feedback_role_arn

  # Firehose endpoint feedback
  firehose_success_feedback_role_arn    = var.topic_config.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.topic_config.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.topic_config.firehose_failure_feedback_role_arn
}
