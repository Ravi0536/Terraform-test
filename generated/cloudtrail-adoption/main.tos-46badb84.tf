module "orders_table" {
  source = "./modules/dynamodb_table"

  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attributes = var.attributes

  global_secondary_indexes = var.global_secondary_indexes

  tags = var.tags
}
