resource "aws_sqs_queue" "payment_callback_dlq" {
  name = "payment-callback-dlq"
}

