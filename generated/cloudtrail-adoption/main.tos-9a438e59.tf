module "aws_dynamodb_table" {
  source = "./modules/aws_dynamodb_table"

  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  attributes   = var.attributes
  tags         = var.tags
}
