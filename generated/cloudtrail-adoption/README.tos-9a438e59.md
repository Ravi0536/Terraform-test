# DynamoDB Table Bundle

## What this bundle creates

This Terraform bundle creates a single AWS DynamoDB table (`tos-mod-e2e-orders4`) in
`us-east-1` using the `PAY_PER_REQUEST` billing mode. The table uses `id` (String) as its
partition key.

The table configuration is encapsulated in the local child module at
`./modules/aws_dynamodb_table`, which exposes a rich interface supporting optional GSIs,
LSIs, server-side encryption, TTL, point-in-time recovery, and DynamoDB Streams via
`dynamic` blocks.

## Directory layout

```
.
├── terraform.tf           # required_version + required_providers
├── providers.tf           # AWS provider configuration
├── variables.tf           # Root-level input variables
├── main.tf                # Module call
├── outputs.tf             # Root-level outputs
├── terraform.tfvars       # Default variable values for this deployment
├── tests/
│   └── dynamodb_table.tftest.hcl   # Validation + plan-mode tests
└── modules/
    └── aws_dynamodb_table/
        ├── main.tf        # aws_dynamodb_table resource with dynamic blocks
        ├── variables.tf   # All configurable inputs
        └── outputs.tf     # id, arn, name, stream_arn, stream_label
```

## How to initialise and plan

```bash
terraform init
terraform plan          # should show exactly 1 resource to create
terraform apply
```

## What an empty plan proves

After a successful `terraform apply`, running `terraform plan` again should show
**"No changes. Your infrastructure matches the configuration."**  This confirms that the
configuration faithfully mirrors every attribute on the real table and that no drift will
occur on subsequent plans.

## Required variables

| Name | Type | Description |
|------|------|-------------|
| `aws_region` | `string` | AWS region for the deployment, e.g. `us-east-1` |
| `table_name` | `string` | DynamoDB table name (3–255 characters) |
| `billing_mode` | `string` | `PAY_PER_REQUEST` or `PROVISIONED` |
| `hash_key` | `string` | Partition key attribute name |
| `attributes` | `list(object)` | Attribute definitions (name + type S/N/B) |
| `tags` | `map(string)` | Resource tags |
