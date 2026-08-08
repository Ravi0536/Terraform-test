aws_region   = "us-east-1"
table_name   = "tos-e2e-orders"
billing_mode = "PAY_PER_REQUEST"
hash_key     = "order_id"

attributes = [
  { name = "created_at", type = "S" },
  { name = "customer_id", type = "S" },
  { name = "order_id", type = "S" },
]

global_secondary_indexes = [
  {
    name            = "by-customer"
    hash_key        = "customer_id"
    range_key       = "created_at"
    projection_type = "ALL"
  },
]

tags = {
  owner   = "ravindra.kande@gmail.com"
  purpose = "user-perspective-testing"
  tos-e2e = "true"
}
