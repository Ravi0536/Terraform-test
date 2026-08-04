# Module: lambda_function

Wraps a single `aws_lambda_function` resource for adoption or creation.

## Usage

```hcl
module "lambda_function" {
  source = "./modules/lambda_function"

  function_name = "my-function"
  role_arn      = module.iam_role.arn
  runtime       = "python3.12"
  handler       = "handler.handler"
  memory_size   = 256
  timeout       = 60

  logging_config = {
    log_format = "Text"
    log_group  = "/aws/lambda/my-function"
  }

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `function_name` | Unique name for the Lambda function (1–64 chars). | `string` | — | yes |
| `role_arn` | ARN of the IAM execution role. | `string` | — | yes |
| `runtime` | Lambda runtime identifier. | `string` | — | yes |
| `handler` | Function entry point. | `string` | — | yes |
| `description` | Human-readable description. | `string` | `null` | no |
| `memory_size` | Memory in MB (128–32768). | `number` | `128` | no |
| `timeout` | Execution timeout in seconds (1–900). | `number` | `3` | no |
| `architectures` | Instruction set architecture list. | `list(string)` | `["x86_64"]` | no |
| `logging_config` | Advanced logging configuration block. | `object({log_format, log_group})` | `null` | no |
| `tags` | Tags to apply to the function. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Name / ID of the Lambda function. |
| `arn` | ARN of the Lambda function. |
| `name` | Name of the Lambda function. |
| `invoke_arn` | Invoke ARN for API Gateway integrations. |
| `qualified_arn` | ARN with version number (when `publish = true`). |
