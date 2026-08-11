module "aws_dynamodb_table" {
  source = "./modules/aws_dynamodb_table"
  name   = "tos-mod-e2e-orders"
  tags = {
    env        = "test"
    managed-by = "tos-e2e"
  }
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
}

