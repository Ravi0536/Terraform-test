module "dynamodb_table" {
  source = "./modules/dynamodb_table"

  name         = var.table_config.name
  billing_mode = var.table_config.billing_mode
  hash_key     = var.table_config.hash_key
  attributes   = var.table_config.attributes

  point_in_time_recovery_enabled = var.table_config.point_in_time_recovery_enabled
  deletion_protection_enabled    = var.table_config.deletion_protection_enabled
  table_class                    = var.table_config.table_class
  stream_enabled                 = var.table_config.stream_enabled
  stream_view_type               = var.table_config.stream_view_type
}

import {
  to = module.dynamodb_table.aws_dynamodb_table.main
  id = "tos-jira-dynamo-test"
}
