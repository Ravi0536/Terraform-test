# Module: dynamodb_table

Encapsulates a single `aws_dynamodb_table` resource with typed inputs,
`dynamic` attribute blocks, and a full set of outputs.

## Usage

```hcl
module "dynamodb_table" {
  source = "./modules/dynamodb_table"

  name         = "my-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attributes = [
    { name = "id", type = "S" }
  ]

  point_in_time_recovery_enabled = true
}
```

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `string` | — | yes | Unique name of the DynamoDB table. |
| `billing_mode` | `string` | — | yes | `PROVISIONED` or `PAY_PER_REQUEST`. |
| `hash_key` | `string` | — | yes | Partition key attribute name. |
| `attributes` | `list(object({name,type}))` | — | yes | Key attribute definitions (`S`, `N`, or `B`). |
| `point_in_time_recovery_enabled` | `bool` | `false` | no | Enable PITR. |
| `deletion_protection_enabled` | `bool` | `false` | no | Enable deletion protection. |
| `table_class` | `string` | `null` | no | `STANDARD` or `STANDARD_INFREQUENT_ACCESS`. |
| `stream_enabled` | `bool` | `false` | no | Enable DynamoDB Streams. |
| `stream_view_type` | `string` | `null` | no | Stream view type when streams are enabled. |

## Outputs

| Name | Description |
|---|---|
| `table_name` | Name of the DynamoDB table. |
| `table_arn` | ARN of the DynamoDB table. |
| `table_id` | ID (name) of the DynamoDB table. |
| `billing_mode` | Billing mode in use. |
| `stream_arn` | Table stream ARN (populated when streams are enabled). |
| `stream_label` | Table stream timestamp label (populated when streams are enabled). |
