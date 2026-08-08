# Module: dynamodb_table

Wraps `aws_dynamodb_table` to provide a reusable, typed interface for adopting or creating DynamoDB tables with optional Global Secondary Indexes.

## Usage

```hcl
module "orders_table" {
  source = "./modules/dynamodb_table"

  name         = "tos-e2e-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"

  attributes = [
    { name = "order_id",   type = "S" },
    { name = "customer_id", type = "S" },
    { name = "created_at",  type = "S" },
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
    owner   = "team@example.com"
    purpose = "orders"
  }
}
```

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `name` | `string` | yes | — | Unique name for the DynamoDB table |
| `hash_key` | `string` | yes | — | Partition key attribute name |
| `billing_mode` | `string` | no | `PAY_PER_REQUEST` | `PROVISIONED` or `PAY_PER_REQUEST` |
| `attributes` | `list(object({name=string,type=string}))` | yes | — | Attribute definitions (hash/range/GSI/LSI keys only) |
| `global_secondary_indexes` | `list(object(...))` | no | `[]` | GSI definitions |
| `tags` | `map(string)` | no | `{}` | Tags applied to the table |

### `attributes` object schema

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Attribute name |
| `type` | `string` | `S`, `N`, or `B` |

### `global_secondary_indexes` object schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | `string` | yes | GSI name |
| `hash_key` | `string` | yes | GSI partition key attribute name |
| `range_key` | `string` | no | GSI sort key attribute name |
| `projection_type` | `string` | yes | `ALL`, `KEYS_ONLY`, or `INCLUDE` |
| `non_key_attributes` | `list(string)` | no | Projected attributes (only for `INCLUDE`) |

## Outputs

| Name | Description |
|------|-------------|
| `table_arn` | ARN of the DynamoDB table |
| `table_id` | Terraform resource ID (equals table name) |
| `table_name` | Name of the DynamoDB table |
| `table_stream_arn` | Stream ARN (empty when streams are off) |
