resource "aws_sqs_queue" "shipment_notify" {
  name                       = "shipment-notify"
  visibility_timeout_seconds = 240

  tags = {
    drift_source = "nrt-e2e"
  }
}
