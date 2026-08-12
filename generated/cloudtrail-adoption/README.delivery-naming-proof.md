# SNS Topic: `delivery-naming-proof`

## What this bundle creates

This Terraform bundle **creates** a single AWS SNS (Simple Notification Service)
standard topic named `delivery-naming-proof` in the `us-east-1` region.

The resource address is:

```
aws_sns_topic.delivery_naming_proof
```

## File layout

| File | Purpose |
|------|---------|
| `terraform.tf` | Terraform version and provider version constraints |
| `providers.tf` | AWS provider configuration |
| `main.tf` | `aws_sns_topic` resource declaration |
| `variables.tf` | All input variable declarations (alphabetical) |
| `outputs.tf` | Output values (ARN, ID, name, owner) |
| `tests/sns_topic.tftest.hcl` | Native Terraform tests (plan-mode, no credentials needed) |

## How to initialise and plan

```bash
# Initialise (downloads provider ~> 5.0)
terraform init

# Plan with defaults (creates delivery-naming-proof)
terraform plan
```

Or override any field via a `terraform.tfvars` file:

```hcl
sns_topic_config = {
  name = "delivery-naming-proof"
}
```

## What an empty plan proves

After `terraform apply`, running `terraform plan` again should show
**"No changes. Your infrastructure matches the configuration."**
This proves that every attribute in `main.tf` mirrors the live resource
exactly and that Terraform will not attempt to modify or replace anything.

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `aws_region` | `string` | No (default `us-east-1`) | AWS region for the SNS topic |
| `sns_topic_config` | `object({...})` | No (default: `{name="delivery-naming-proof"}`) | Full SNS topic configuration (see `variables.tf` for all fields) |

### `sns_topic_config` object fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | `string` | **Yes** | Topic name (1-256 chars, `[A-Za-z0-9_-]`, `.fifo` suffix for FIFO) |
| `display_name` | `string` | No | Display name shown in SMS messages |
| `fifo_topic` | `bool` | No | Enable FIFO ordering (default `false`) |
| `content_based_deduplication` | `bool` | No | Enable content-based deduplication for FIFO topics |
| `fifo_throughput_scope` | `string` | No | `"Topic"` or `"MessageGroup"` |
| `archive_policy` | `string` | No | Message archive policy JSON for FIFO topics |
| `policy` | `string` | No | Resource-based IAM policy JSON |
| `delivery_policy` | `string` | No | SNS delivery retry policy JSON |
| `kms_master_key_id` | `string` | No | KMS CMK ID/ARN/alias for server-side encryption |
| `signature_version` | `number` | No | `1` (SHA1) or `2` (SHA256) |
| `tracing_config` | `string` | No | `"PassThrough"` or `"Active"` |
| `*_success_feedback_role_arn` | `string` | No | IAM role ARN for delivery success CloudWatch logging |
| `*_success_feedback_sample_rate` | `number` | No | Sampling rate 0–100 for success feedback |
| `*_failure_feedback_role_arn` | `string` | No | IAM role ARN for delivery failure CloudWatch logging |

Endpoint prefixes: `application`, `http`, `lambda`, `sqs`, `firehose`.

## Outputs

| Name | Description |
|------|-------------|
| `sns_topic_arn` | Full ARN of the SNS topic |
| `sns_topic_id` | Terraform resource ID (same as ARN) |
| `sns_topic_name` | Name of the SNS topic |
| `sns_topic_owner` | AWS account ID that owns the topic |

## Running tests

```bash
terraform test
```

All tests run in **plan mode** — no AWS credentials are required and
no real infrastructure is created.
