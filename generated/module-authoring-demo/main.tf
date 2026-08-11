module "aws_dynamodb_table" {
  source = "./modules/aws_dynamodb_table"

  name                           = var.table_name
  billing_mode                   = var.billing_mode
  hash_key                       = var.hash_key
  range_key                      = var.range_key
  read_capacity                  = var.read_capacity
  write_capacity                 = var.write_capacity
  table_class                    = var.table_class
  stream_enabled                 = var.stream_enabled
  stream_view_type               = var.stream_view_type
  deletion_protection_enabled    = var.deletion_protection_enabled
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  server_side_encryption         = var.server_side_encryption
  ttl                            = var.ttl
  attributes                     = var.attributes
  global_secondary_indexes       = var.global_secondary_indexes
  local_secondary_indexes        = var.local_secondary_indexes
  tags                           = var.tags
}
