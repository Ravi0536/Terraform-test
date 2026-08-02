# S3 Bucket Adoption Bundle

## What this bundle adopts

This Terraform bundle brings an **existing** AWS S3 bucket and its associated
sub-resources under Terraform management without creating, replacing, or
destroying anything.

| Resource | Import ID |
|---|---|
| `aws_s3_bucket` | `cf-templates-tiv18fhdp46w-us-east-1` |
| `aws_s3_bucket_server_side_encryption_configuration` | `cf-templates-tiv18fhdp46w-us-east-1` |
| `aws_s3_bucket_public_access_block` | `cf-templates-tiv18fhdp46w-us-east-1` |
| `aws_s3_bucket_ownership_controls` | `cf-templates-tiv18fhdp46w-us-east-1` |

The bucket (`cf-templates-tiv18fhdp46w-us-east-1`) is a CloudFormation
template storage bucket in `us-east-1` with:

- **AES256** server-side encryption (no bucket key)
- All **public-access-block** settings enabled
- **BucketOwnerEnforced** object ownership (ACLs disabled)
- Tag: `tos-drift-test = "1"`

## Prerequisites

- Terraform `>= 1.9.0`
- AWS provider `~> 6.0`
- AWS credentials with read access to the bucket (for the first `plan`/`apply`
  that performs the import)

## How to initialise and import

```bash
# 1. Initialise providers
terraform init

# 2. Preview the import – should show no attribute drift
terraform plan -var-file=terraform.tfvars

# 3. Adopt the resources into state
terraform apply -var-file=terraform.tfvars
```

## Proving an empty plan

After the initial `terraform apply` every subsequent `plan` must show
**"No changes. Your infrastructure matches the configuration."**

```bash
terraform plan -var-file=terraform.tfvars -detailed-exitcode
# Exit code 0 ⟹ empty plan ✓
```

## Running tests

```bash
terraform test
```

Tests run in **plan mode** and require no real credentials (all assertions are
evaluated against the generated plan graph).

## File layout

```
.
├── terraform.tf           # required_version + required_providers
├── providers.tf           # AWS provider configuration
├── main.tf                # import blocks + module call
├── variables.tf           # root-level input variables
├── outputs.tf             # root-level outputs
├── locals.tf              # shared local values
├── terraform.tfvars       # live values (matches real infrastructure)
├── tests/
│   └── s3_bucket.tftest.hcl
└── modules/
    └── s3_bucket/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```
