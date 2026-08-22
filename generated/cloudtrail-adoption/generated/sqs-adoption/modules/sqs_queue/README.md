# Module: sqs_queue

Manages a single Amazon SQS queue. Designed for adoption of an existing queue via an `import` block in the root configuration.

## Usage

```hcl
module "sqs_queue" {
  source = "./modules/sqs_queue"

  name                      = "my-queue"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true

  tags = {
    env = "production"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | `string` | — | yes | Queue name (1–80 chars; FIFO queues must end with `.fifo`). |
| `message_retention_seconds` | `number` | `1209600` | no | Seconds SQS retains a message (60–1209600). |
| `sqs_managed_sse_enabled` | `bool` | `true` | no | Enable SQS-managed SSE. |
| `tags` | `map(string)` | `{}` | no | Tags to apply to the queue. |

## Outputs

| Name | Description |
|------|-------------|
| `queue_id` | URL of the queue (Terraform resource id). |
| `queue_arn` | ARN of the queue. |
| `queue_url` | URL of the queue. |
| `queue_name` | Name of the queue. |
