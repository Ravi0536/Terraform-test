resource "aws_sqs_queue" "shipment_notify" {
  name                       = "shipment-notify"
  visibility_timeout_seconds = 240
  sqs_managed_sse_enabled    = true

  tags = {
    drift_source = "nrt-e2e"
  }
}

import {
  to = aws_sqs_queue.shipment_notify
  id = "https://sqs.us-east-1.amazonaws.com/346589946607/shipment-notify"
}
