aws_region   = "us-east-1"
table_name   = "tos-mod-e2e-orders4"
billing_mode = "PAY_PER_REQUEST"
hash_key     = "id"

attributes = [
  {
    name = "id"
    type = "S"
  }
]

tags = {
  env        = "test"
  managed-by = "tos-e2e"
}
