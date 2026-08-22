# sqs-adoption

Adopts an existing AWS SQS queue into Terraform management without recreating or modifying it.

## What this bundle adopts

| Resource | AWS identifier |
|----------|---------------|
| `aws_sqs_queue` | `https://sqs.us-east-1.amazonaws.com/346589946607/tos-jira-agentic-e2e` |

The queue `tos-jira-agentic-e2e` is a standard (non-FIFO) SQS queue in `us-east-1` with:
- 14-day message retention (`message_retention_seconds = 1209600`)
- SQS-managed server-side encryption enabled (`sqs_managed_sse_enabled = true`)
- Tag: `lane_drift_probe = "0822b"`

## Module structure

```
generated/sqs-adoption/
├── terraform.tf          # Terraform & provider version requirements
├── providers.tf          # AWS provider configuration
├── main.tf               # Import block + module call
├── variables.tf          # Root input variables
├── outputs.tf            # Root outputs
├── modules/
│   └── sqs_queue/
│       ├── main.tf       # aws_sqs_queue resource
│       ├── variables.tf  # Module input variables
│       └── outputs.tf    # Module outputs
└── tests/
    └── unit_test.tftest.hcl  # Plan-mode tests (no credentials needed)
```

## How to init and plan

```bash
cd generated/sqs-adoption

# Initialise (downloads provider, loads local module)
terraform init

# Preview the import – should show the resource being imported
# with zero attribute changes (empty diff after import)
terraform plan

# Apply the import to bring the queue under Terraform management
terraform apply
```

## What "empty plan" proves

After a successful `terraform apply` of the import, running `terraform plan` again should output:

```
No changes. Your infrastructure matches the configuration.
```

This confirms the resource is fully under Terraform management and that the configuration exactly mirrors the live AWS state – no drift, no pending changes.

## Requirements

| Tool | Version |
|------|---------|
| Terraform | `>= 1.9.0` |
| AWS provider | `~> 5.0` |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `queue_config` | `object` | see variables.tf | Queue configuration (name, retention, SSE). |
| `tags` | `map(string)` | `{ lane_drift_probe = "0822b" }` | Tags to apply to the queue. |

## Outputs

| Name | Description |
|------|-------------|
| `queue_id` | URL / Terraform id of the queue. |
| `queue_arn` | ARN of the queue. |
| `queue_url` | URL of the queue. |
| `queue_name` | Name of the queue. |
