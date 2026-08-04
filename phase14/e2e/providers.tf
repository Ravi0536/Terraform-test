# Two providers are required:
# - default (us-east-1) for the Lambda function
# - no alias needed for IAM (global service), but region must be a valid AWS region
provider "aws" {
  region = "us-east-1"
}
