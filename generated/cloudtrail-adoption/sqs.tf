resource "aws_sqs_queue" "shipment_notify" {
  name                       = "shipment-notify"
  visibility_timeout_seconds = 180

  tags = {
    drift_source = "manual-console-change"
  }
}
