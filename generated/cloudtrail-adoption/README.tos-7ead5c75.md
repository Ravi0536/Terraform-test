# tos-extensibility-proof SQS Queue

## What this bundle adopts

This Terraform configuration creates and manages a single Amazon SQS **standard queue** named `tos-extensibility-proof` in `us-east-1`.

| Resource address | Type | Name |
|---|---|---|
| `aws_sqs_queue.tos_extensibility_proof` | `aws_sqs_queue` | `tos-extensibility-proof` |

---

## Prerequisites

| Tool | Minimum version |
|---|---|
| Terraform | 1.9.0 |
| AWS provider | ~> 6.0 |

Valid AWS credentials must be available in the environment (environment variables, shared credentials file, or IAM role).

---

## How to initialise and plan

```bash
# 1. Initialise providers
terraform init

# 2. Preview the execution plan — should show exactly 1 resource to create
terraform plan

# 3. Apply (creates the queue)
terraform apply
```

An **empty plan** (0 to add, 0 to change, 0 to destroy) after the first `apply` proves that the configuration exactly mirrors the real queue with no drift.

---

## File layout

| File | Purpose |
|---|---|
| `terraform.tf` | Terraform version & provider version constraints |
| `providers.tf` | AWS provider configuration |
| `variables.tf` | All input variable declarations (alphabetical) |
| `locals.tf` | Derived / computed local values |
| `main.tf` | The `aws_sqs_queue` resource |
| `outputs.tf` | Exposed attributes (ARN, URL, name) |
| `terraform.tfvars` | Default variable values for the real queue |
| `tests/` | Native Terraform test files (plan-mode only) |

---

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `aws_region` | `string` | `"us-east-1"` | AWS region |
| `queue_name` | `string` | — **required** | SQS queue name |
| `delay_seconds` | `number` | `0` | Delivery delay (0–900 s) |
| `max_message_size` | `number` | `262144` | Max message size in bytes (1 KiB – 1 MiB) |
| `message_retention_seconds` | `number` | `345600` | Message retention (60 s – 14 days) |
| `receive_wait_time_seconds` | `number` | `0` | Long-poll wait time (0–20 s) |
| `visibility_timeout_seconds` | `number` | `30` | Visibility timeout (0–43200 s) |
| `fifo_queue` | `bool` | `false` | Create a FIFO queue |
| `content_based_deduplication` | `bool` | `false` | FIFO content-based deduplication |
| `deduplication_scope` | `string` | `null` | `"messageGroup"` or `"queue"` |
| `fifo_throughput_limit` | `string` | `null` | `"perQueue"` or `"perMessageGroupId"` |
| `sqs_managed_sse_enabled` | `bool` | `null` | Enable SSE-SQS encryption |
| `kms_master_key_id` | `string` | `null` | KMS key ID for SSE-KMS |
| `kms_data_key_reuse_period_seconds` | `number` | `null` | KMS data-key reuse period (60–86400 s) |
| `policy` | `string` | `null` | Inline IAM policy JSON |
| `redrive_policy` | `string` | `null` | Dead-letter queue redrive policy JSON |
| `redrive_allow_policy` | `string` | `null` | Redrive-allow policy JSON |

## Outputs

| Name | Description |
|---|---|
| `queue_arn` | ARN of the SQS queue |
| `queue_id` | URL / ID of the SQS queue |
| `queue_name` | Name of the SQS queue |
| `queue_url` | URL of the SQS queue |

---

## Running tests (plan-mode, no credentials required*)

```bash
terraform test
```

> \* Plan-mode tests validate variable constraints and plan-time invariants locally. Tests will still call the AWS provider for a mock plan; set dummy credentials if needed:
> ```bash
> export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test
> terraform test
> ```
