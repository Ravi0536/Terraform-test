# DynamoDB Table — Terraform Adoption Bundle

## What This Bundle Adopts

This bundle brings an existing AWS DynamoDB table under Terraform management
**without creating, replacing, or destroying any real infrastructure**.

| Resource | AWS Type | Import ID |
|---|---|---|
| `module.dynamodb_table` | `aws_dynamodb_table` | `tos-jira-dynamo-test` |

The table (`tos-jira-dynamo-test`) is a PAY_PER_REQUEST table with a single
string hash key (`id`) and point-in-time recovery enabled, located in
`us-east-1`.

## Bundle Layout

```
.
├── terraform.tf          # Version constraints (Terraform ≥ 1.9.0, AWS ~> 6.0)
├── providers.tf          # AWS provider configuration
├── variables.tf          # Root input variables
├── locals.tf             # Derived locals
├── main.tf               # Module instantiation + import block
├── outputs.tf            # Root outputs
├── terraform.tfvars      # Variable values matching the live resource
├── modules/
│   └── dynamodb_table/
│       ├── terraform.tf  # Module version constraints
│       ├── variables.tf  # Module input variables
│       ├── main.tf       # aws_dynamodb_table resource
│       └── outputs.tf    # Module outputs
└── tests/
    └── dynamodb_table.tftest.hcl  # Native Terraform tests (plan mode)
```

## Prerequisites

- Terraform `>= 1.9.0`
- AWS credentials with read access to DynamoDB in `us-east-1`

## How to Init and Plan

```bash
# Initialise providers and modules (internet access required)
terraform init

# Preview the import — the plan must show 0 additions, 0 destructions
terraform plan

# Import and record the resource in state
terraform apply
```

## What an Empty Plan Proves

After `terraform apply` completes the initial import, running `terraform plan`
again should report:

```
No changes. Your infrastructure matches the configuration.
```

This confirms that every attribute in `variables.tf` / `terraform.tfvars`
accurately mirrors the live resource and that no unintended drift will occur.

## Running Tests

```bash
# All tests run in plan mode — no AWS credentials needed for validation tests
terraform test
```

## Inputs

| Name | Type | Description |
|---|---|---|
| `aws_region` | `string` | AWS region where the table is managed (default: `us-east-1`) |
| `table_config` | `object` | Full configuration object for the DynamoDB table (see `variables.tf`) |

## Outputs

| Name | Description |
|---|---|
| `table_name` | Name of the DynamoDB table |
| `table_arn` | ARN of the DynamoDB table |
| `table_id` | ID (name) of the DynamoDB table |
| `billing_mode` | Billing mode of the DynamoDB table |
| `stream_arn` | ARN of the table stream (empty when streams are disabled) |
| `stream_label` | Timestamp label of the table stream (empty when streams are disabled) |
