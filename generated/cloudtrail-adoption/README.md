# terraform-aws-dynamodb-table

Adopts an existing AWS DynamoDB table into Terraform management without creating, replacing, or destroying any real infrastructure.

## What This Bundle Adopts

| Resource | AWS ARN |
|----------|---------|
| `aws_dynamodb_table` | `arn:aws:dynamodb:us-east-1:346589946607:table/tos-e2e-orders` |

The table is an on-demand (`PAY_PER_REQUEST`) DynamoDB table named **tos-e2e-orders** with a single GSI (`by-customer`) used for end-to-end testing.

## Repository Layout

```
.
├── terraform.tf          # Terraform + provider version pins
├── providers.tf          # AWS provider configuration
├── main.tf               # Root module – wires variables into the child module
├── variables.tf          # All root input variables (typed, described, validated)
├── outputs.tf            # Root outputs (table ARN, ID, name, stream ARN)
├── imports.tf            # import{} block – brings the existing table under management
├── terraform.tfvars      # Concrete values that match the real resource
├── locals.tf             # (empty – no locals required at root level)
├── tests/
│   └── dynamodb_table.tftest.hcl   # Variable-validation + plan-time tests
└── modules/
    └── dynamodb_table/
        ├── terraform.tf  # Provider version requirement for the module
        ├── main.tf       # aws_dynamodb_table resource with dynamic blocks
        ├── variables.tf  # Module input variables
        └── outputs.tf    # Module outputs
```

## Prerequisites

- Terraform `>= 1.9.0`
- AWS credentials with read access to DynamoDB (for `terraform plan` / `terraform apply`)

## Usage

### 1. Initialise

```bash
terraform init
```

### 2. Plan (adoption dry-run)

```bash
terraform plan -var-file=terraform.tfvars
```

An **empty plan** (0 adds, 0 changes, 0 destroys) after `terraform apply` proves that the
configuration is an exact mirror of the real table — no drift introduced.

### 3. Apply (first run — imports the table)

```bash
terraform apply -var-file=terraform.tfvars
```

The `import` block in `imports.tf` brings `tos-e2e-orders` under Terraform state on the
first `apply`. Subsequent plans should show no changes.

## What "Empty Plan" Proves

After the initial import apply:

```
No changes. Your infrastructure matches the configuration.
```

This confirms:
- Every attribute in `terraform.tfvars` exactly matches the live resource.
- No extra defaults, tags, or attributes were injected.
- The DynamoDB table is fully under Terraform's management without recreation.

## Inputs

See [`variables.tf`](./variables.tf) for the full list of typed, validated variables.

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `aws_region` | `string` | yes | AWS region of the table |
| `table_name` | `string` | yes | DynamoDB table name |
| `billing_mode` | `string` | no (default `PAY_PER_REQUEST`) | Billing mode |
| `hash_key` | `string` | yes | Partition key attribute name |
| `attributes` | `list(object)` | yes | Attribute definitions |
| `global_secondary_indexes` | `list(object)` | no | GSI definitions |
| `tags` | `map(string)` | no | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `table_arn` | ARN of the DynamoDB table |
| `table_id` | Terraform ID of the table (equals the table name) |
| `table_name` | Name of the DynamoDB table |
| `table_stream_arn` | ARN of the table stream (empty when streams are disabled) |
