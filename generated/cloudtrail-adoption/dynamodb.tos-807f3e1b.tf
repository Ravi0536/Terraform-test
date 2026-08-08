
resource "aws_dynamodb_table" "tos_jira_dynamo_test" {
  name         = "tos-jira-dynamo-test"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
}
