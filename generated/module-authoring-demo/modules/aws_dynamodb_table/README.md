# Module: aws_dynamodb_table

Creates an AWS DynamoDB table with full support for billing modes, streams,
Point-in-Time Recovery, server-side encryption, TTL, Global Secondary Indexes,
and Local Secondary Indexes.

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

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Table name (3–255 characters) |
| `billing_mode` | `string` | `PAY_PER_REQUEST` | PROVISIONED or PAY_PER_REQUEST |
| `hash_key` | `string` | — | Partition key attribute name |
| `range_key` | `string` | `null` | Sort key attribute name |
| `read_capacity` | `number` | `null` | Read capacity units (PROVISIONED) |
| `write_capacity` | `number` | `null` | Write capacity units (PROVISIONED) |
| `table_class` | `string` | `null` | STANDARD or STANDARD_INFREQUENT_ACCESS |
| `stream_enabled` | `bool` | `false` | Enable DynamoDB Streams |
| `stream_view_type` | `string` | `null` | Stream view: KEYS_ONLY / NEW_IMAGE / OLD_IMAGE / NEW_AND_OLD_IMAGES |
| `deletion_protection_enabled` | `bool` | `false` | Enable deletion protection |
| `point_in_time_recovery_enabled` | `bool` | `false` | Enable Point-in-Time Recovery |
| `server_side_encryption` | `object({enabled, kms_key_arn})` | `null` | SSE configuration |
| `ttl` | `object({enabled, attribute_name})` | `null` | TTL configuration |
| `attributes` | `list(object({name, type}))` | `[]` | Attribute definitions (S/N/B) |
| `global_secondary_indexes` | `list(object(...))` | `[]` | GSI definitions |
| `local_secondary_indexes` | `list(object(...))` | `[]` | LSI definitions |
| `tags` | `map(string)` | `{}` | Tags to apply to the table |

## Outputs

| Name | Description |
|------|-------------|
| `id` | ID (name) of the DynamoDB table |
| `arn` | ARN of the DynamoDB table |
| `name` | Name of the DynamoDB table |
| `stream_arn` | ARN of the table stream (when enabled) |
| `stream_label` | ISO 8601 timestamp of the stream (when enabled) |
| `billing_mode` | Billing mode of the table |
| `hash_key` | Partition key attribute name |
