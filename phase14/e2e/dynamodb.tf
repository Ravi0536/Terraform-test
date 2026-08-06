resource "aws_dynamodb_table" "tos_test_counter" {
  name         = "tos-test-counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

