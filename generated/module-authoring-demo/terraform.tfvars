# Required variables — no sensitive defaults are set here.
# Copy this file to terraform.tfvars and supply real values.

region       = "us-east-1"
table_name   = "tos-mod-e2e-orders5"
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
