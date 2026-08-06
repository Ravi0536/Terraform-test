resource "aws_dynamodb_table" "failed_payment_events" {
  name         = "failed-payment-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

