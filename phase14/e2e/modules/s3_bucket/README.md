# Module: s3_bucket

Manages an S3 bucket together with its server-side encryption configuration,
public-access block, and object-ownership controls.

## Usage

```hcl
module "my_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = "my-existing-bucket"
  aws_region  = "us-east-1"

  tags = {
    Environment = "production"
  }

  server_side_encryption = {
    sse_algorithm      = "AES256"
    bucket_key_enabled = false
  }

  public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  object_ownership = "BucketOwnerEnforced"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `bucket_name` | Name / ID of the S3 bucket | `string` | — | yes |
| `aws_region` | AWS region the bucket resides in | `string` | — | yes |
| `tags` | Tags applied to all resources | `map(string)` | `{}` | no |
| `server_side_encryption` | SSE configuration object; `null` = unmanaged | `object({…})` | `null` | no |
| `public_access_block` | Public-access-block settings; `null` = unmanaged | `object({…})` | `null` | no |
| `object_ownership` | Object-ownership rule | `string` | `"BucketOwnerEnforced"` | no |

### `server_side_encryption` object

| Attribute | Type | Description |
|---|---|---|
| `sse_algorithm` | `string` | `AES256`, `aws:kms`, or `aws:kms:dsse` |
| `bucket_key_enabled` | `bool` | Enable S3 Bucket Key (reduces KMS costs) |

### `public_access_block` object

| Attribute | Type | Description |
|---|---|---|
| `block_public_acls` | `bool` | Block public ACLs |
| `block_public_policy` | `bool` | Block public bucket policies |
| `ignore_public_acls` | `bool` | Ignore public ACLs |
| `restrict_public_buckets` | `bool` | Restrict public bucket access |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | Name / ID of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `bucket_region` | AWS region of the bucket |
| `bucket_domain_name` | Regional domain name of the bucket |
| `encryption_enabled` | `true` if SSE configuration is managed by this module |
| `public_access_block_enabled` | `true` if public-access block is managed by this module |
| `object_ownership` | Object-ownership rule in effect |
