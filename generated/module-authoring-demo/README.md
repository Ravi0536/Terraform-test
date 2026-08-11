# DynamoDB Table — Terraform Bundle

## What this bundle adopts

This bundle creates a single AWS DynamoDB table (`tos-mod-e2e-orders5`) in the
`us-east-1` region under account `346589946607`. The table uses on-demand
(`PAY_PER_REQUEST`) billing with a string partition key named `id`.

The exact resource address placed under management is:

```
module.aws_dynamodb_table.aws_dynamodb_table.this
```

## Directory layout

```
.
├── terraform.tf          # Version constraints
├── providers.tf          # AWS provider configuration
├── main.tf               # Root module — calls the DynamoDB module
├── variables.tf          # All input variables with types, descriptions, validations
├── outputs.tf            # Key outputs forwarded from the child module
├── terraform.tfvars      # Example variable values (copy/edit before running)
├── modules/
│   └── aws_dynamodb_table/
│       ├── main.tf       # aws_dynamodb_table resource with dynamic blocks
│       ├── variables.tf  # Module input variables
│       └── outputs.tf    # Module outputs
├── tests/
│   └── unit_test.tftest.hcl  # Plan-mode tests (no credentials required)
└── README.md             # This file
```

## Prerequisites

- Terraform >= 1.9.0
- AWS credentials with `dynamodb:CreateTable` and related permissions
- An existing AWS account (`346589946607`) and region (`us-east-1`)

## Usage

### 1. Initialise

```bash
terraform init
```

### 2. Review the plan

```bash
terraform plan -var-file=terraform.tfvars
```

An **empty plan** (no changes) after the first `terraform apply` proves the
configuration exactly mirrors the live table — no drift.

### 3. Apply

```bash
terraform apply -var-file=terraform.tfvars
```

### 4. Run unit tests (no credentials required for plan-mode)

```bash
terraform test
```

## What an empty plan proves

After the initial apply, running `terraform plan` again and seeing
**"No changes. Your infrastructure matches the configuration."** confirms:

- Every attribute in the Terraform configuration matches what AWS reports for
  the live table.
- No unintended side-effects (extra tags, changed billing mode, etc.) will be
  applied on subsequent runs.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `region` | `string` | `us-east-1` | AWS region |
| `table_name` | `string` | — | DynamoDB table name (3–255 chars) |
| `billing_mode` | `string` | `PAY_PER_REQUEST` | PROVISIONED or PAY_PER_REQUEST |
| `hash_key` | `string` | — | Partition key attribute name |
| `range_key` | `string` | `null` | Sort key attribute name |
| `read_capacity` | `number` | `null` | Read capacity (PROVISIONED only) |
| `write_capacity` | `number` | `null` | Write capacity (PROVISIONED only) |
| `table_class` | `string` | `null` | STANDARD or STANDARD_INFREQUENT_ACCESS |
| `stream_enabled` | `bool` | `false` | Enable DynamoDB Streams |
| `stream_view_type` | `string` | `null` | Stream record content |
| `deletion_protection_enabled` | `bool` | `false` | Enable deletion protection |
| `point_in_time_recovery_enabled` | `bool` | `false` | Enable PITR |
| `server_side_encryption` | `object` | `null` | SSE configuration |
| `ttl` | `object` | `null` | TTL configuration |
| `attributes` | `list(object)` | `[]` | Key attribute definitions |
| `global_secondary_indexes` | `list(object)` | `[]` | GSI definitions |
| `local_secondary_indexes` | `list(object)` | `[]` | LSI definitions |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `table_id` | ID (name) of the DynamoDB table |
| `table_arn` | ARN of the DynamoDB table |
| `table_name` | Name of the DynamoDB table |
| `table_stream_arn` | Stream ARN (when streams are enabled) |
| `table_stream_label` | Stream timestamp (when streams are enabled) |
