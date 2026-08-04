# Module: iam_role

Wraps a single `aws_iam_role` resource for adoption or creation.

## Usage

```hcl
module "iam_role" {
  source = "./modules/iam_role"

  name = "my-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Friendly name of the IAM role (1–64 chars). | `string` | — | yes |
| `assume_role_policy` | JSON trust-policy document. | `string` | — | yes |
| `description` | Optional human-readable description. | `string` | `null` | no |
| `path` | IAM path for the role. | `string` | `null` | no |
| `max_session_duration` | Max session in seconds (3600–43200). | `number` | `null` | no |
| `permissions_boundary` | ARN of a permissions-boundary policy. | `string` | `null` | no |
| `tags` | Tags to apply to the role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Name / ID of the IAM role. |
| `arn` | ARN of the IAM role. |
| `name` | Name of the IAM role. |
| `unique_id` | Stable unique identifier for the role. |
