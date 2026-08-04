# TOS Resource Counter — Terraform Adoption Bundle

This bundle **adopts** two existing AWS resources into Terraform management
without creating, replacing, or destroying anything.

## Resources adopted

| Terraform address | AWS resource | Import ID |
|---|---|---|
| `module.iam_role.aws_iam_role.main` | `arn:aws:iam::346589946607:role/tos-resource-counter-role` | `tos-resource-counter-role` |
| `module.lambda_function.aws_lambda_function.main` | `arn:aws:lambda:us-east-1:346589946607:function:tos-resource-counter` | `tos-resource-counter` |

## Repository layout

```
.
├── terraform.tf          # required_version + required_providers
├── providers.tf          # AWS provider configuration
├── main.tf               # import blocks + module calls
├── variables.tf          # typed, validated root variables
├── outputs.tf            # key resource attributes exposed at root
├── terraform.tfvars      # live values matching the adopted resources
├── tests/
│   └── adoption.tftest.hcl   # plan-mode tests (no credentials needed)
└── modules/
    ├── iam_role/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── README.md
    │   └── tests/unit.tftest.hcl
    └── lambda_function/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── README.md
        └── tests/unit.tftest.hcl
```

## Prerequisites

- Terraform >= 1.9.0
- AWS credentials with read access to IAM and Lambda in `us-east-1`

## How to adopt

```bash
# 1. Initialise providers
terraform init

# 2. Preview — should show only import operations, zero resource changes
terraform plan

# 3. Adopt (import + align state, no infrastructure changes)
terraform apply
```

## Verifying a clean plan

After a successful `terraform apply`, run:

```bash
terraform plan
```

An **empty plan** (no changes, no drift) confirms the configuration exactly
mirrors the live resources and the adoption is complete.

## Running tests

```bash
# Root-level plan tests (no credentials needed)
terraform test

# Module-level unit tests
terraform test -chdir=modules/iam_role
terraform test -chdir=modules/lambda_function
```
