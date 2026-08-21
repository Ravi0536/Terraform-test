resource "aws_sqs_queue" "shipment_notify" {
  name                       = "shipment-notify"
  visibility_timeout_seconds = 240

  tags = {
    drift_source = "nrt-e2e"
  }
}

resource "aws_sqs_queue" "payment_callback_dlq" {
  name                      = "payment-callback-dlq"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
}

import {
  to = aws_sqs_queue.payment_callback_dlq
  id = "https://sqs.us-east-1.amazonaws.com/346589946607/payment-callback-dlq"
}
