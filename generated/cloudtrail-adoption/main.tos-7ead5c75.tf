# ---------------------------------------------------------------------------
# SQS Queue
# ---------------------------------------------------------------------------

resource "aws_sqs_queue" "tos_extensibility_proof" {
  name = var.queue_name

  # Delivery / retention
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # FIFO settings (only meaningful when fifo_queue = true)
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit

  # Encryption
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  # Access / redrive
  policy               = var.policy
  redrive_policy       = var.redrive_policy
  redrive_allow_policy = var.redrive_allow_policy
}
