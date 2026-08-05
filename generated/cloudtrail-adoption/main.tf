resource "aws_dynamodb_table" "tos_dev_agent_runs" {
  name         = "tos-dev-agent-runs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = "arn:aws:kms:us-east-1:346589946607:key/4b9015e5-cf84-457f-9303-983f29f72b65"
  }

  tags = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    phase       = "4"
    service     = "tos"
  }
}

import {
  to = aws_dynamodb_table.tos_dev_agent_runs
  id = "tos-dev-agent-runs"
}
