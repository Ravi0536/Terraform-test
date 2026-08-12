# SNS Topic – vendor-naming-proof

This Terraform bundle provisions a single AWS SNS topic (`vendor-naming-proof`)
together with full lifecycle configuration (encryption, delivery feedback,
FIFO, tracing, and message archive policies).

## What this bundle creates

| Resource address | Type | Description |
|---|---|---|
| `aws_sns_topic.vendor_naming_proof` | `aws_sns_topic` | Standard SNS topic named `vendor-naming-proof` |

## Prerequisites

- Terraform `>= 1.9.0`
- AWS provider `~> 6.0` (declared in the parent repository root)
- AWS credentials available in the environment (for a real apply)

## Initialise and plan

```bash
# Initialise (downloads the AWS provider)
terraform init

# Preview – uses the built-in default (name = "vendor-naming-proof")
terraform plan

# Override with a custom config
terraform plan -var='topic_config={"name":"vendor-naming-proof"}'
```

## What an "empty plan" proves

After applying this bundle, re-running `terraform plan` should produce
**"No changes. Your infrastructure matches the configuration."** This confirms:

1. The resource was created with exactly the attributes declared in the config.
2. Terraform has no drift to reconcile.

## Inputs

The single `topic_config` object variable has a built-in default of
`{ name = "vendor-naming-proof" }`, so no `-var` flag is required for a
vanilla plan or apply.

See [`variables.tf`](./variables.tf) for the full schema and all validation
rules.

### Minimal example

```hcl
topic_config = {
  name = "vendor-naming-proof"
}
```

### FIFO topic example

```hcl
topic_config = {
  name                        = "my-events.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
  fifo_throughput_scope       = "MessageGroup"
}
```

### Encrypted topic with delivery tracing

```hcl
topic_config = {
  name              = "vendor-naming-proof"
  kms_master_key_id = "alias/aws/sns"
  tracing_config    = "Active"
  signature_version = 2
}
```

## Outputs

| Name | Description |
|---|---|
| `arn` | ARN of the SNS topic |
| `id` | ARN of the SNS topic (canonical id) |
| `name` | Name of the SNS topic |
| `owner` | AWS account ID of the topic owner |
| `beginning_archive_time` | Oldest replay timestamp (FIFO topics only) |

## Running the tests

```bash
terraform test
```

All tests run in `plan` mode and require no AWS credentials.

## File layout

```
.
├── main.tf          # aws_sns_topic resource
├── variables.tf     # Typed, validated topic_config variable
├── outputs.tf       # Key topic attributes as outputs
├── README.md        # This file
└── tests/
    └── sns_topic.tftest.hcl  # Plan-mode unit tests
```
