aws_region = "us-east-1"

table_config = {
  name         = "tos-jira-dynamo-test"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  point_in_time_recovery_enabled = true
  deletion_protection_enabled    = false
  table_class                    = null
  stream_enabled                 = false
  stream_view_type               = null
}
