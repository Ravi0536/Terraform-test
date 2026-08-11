# Module: aws_dynamodb_table

Creates an `aws_dynamodb_table` resource with full support for optional indexes,
encryption, TTL, streams, and point-in-time recovery via Terraform `dynamic` blocks.

## Usage

```hcl
module "aws_dynamodb_table" {
  source = "./modules/aws_dynamodb_table"

  name         = "my-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attributes = [
    { name = "id", type = "S" }
  ]

  tags = {
    env = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | `string` | — | **yes** | DynamoDB table name |
| `billing_mode` | `string` | `"PAY_PER_REQUEST"` | no | `PAY_PER_REQUEST` or `PROVISIONED` |
| `hash_key` | `string` | — | **yes** | Partition key attribute name |
| `range_key` | `string` | `null` | no | Sort key attribute name |
| `read_capacity` | `number` | `null` | no | Required for PROVISIONED mode |
| `write_capacity` | `number` | `null` | no | Required for PROVISIONED mode |
| `attributes` | `list(object({name, type}))` | `[]` | no | Key attribute definitions |
| `table_class` | `string` | `null` | no | `STANDARD` or `STANDARD_INFREQUENT_ACCESS` |
| `stream_enabled` | `bool` | `false` | no | Enable DynamoDB Streams |
| `stream_view_type` | `string` | `null` | no | Stream record format |
| `deletion_protection_enabled` | `bool` | `false` | no | Protect against accidental deletion |
| `point_in_time_recovery_enabled` | `bool` | `false` | no | Enable PITR backups |
| `server_side_encryption` | `object` | `null` | no | SSE configuration |
| `ttl` | `object` | `null` | no | TTL configuration |
| `global_secondary_indexes` | `list(object)` | `[]` | no | GSI definitions |
| `local_secondary_indexes` | `list(object)` | `[]` | no | LSI definitions |
| `tags` | `map(string)` | `{}` | no | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The name/ID of the DynamoDB table |
| `arn` | The ARN of the DynamoDB table |
| `name` | The name of the DynamoDB table |
| `stream_arn` | Stream ARN (populated when `stream_enabled = true`) |
| `stream_label` | Stream label timestamp (populated when `stream_enabled = true`) |
