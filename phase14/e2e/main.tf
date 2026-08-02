# ---------------------------------------------------------------------------
# Import blocks – IDs are verbatim from the adoption manifest.
# ---------------------------------------------------------------------------

import {
  to = module.cf_templates_bucket.aws_s3_bucket.main
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

import {
  to = module.cf_templates_bucket.aws_s3_bucket_server_side_encryption_configuration.main[0]
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

import {
  to = module.cf_templates_bucket.aws_s3_bucket_public_access_block.main[0]
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

import {
  to = module.cf_templates_bucket.aws_s3_bucket_ownership_controls.main
  id = "cf-templates-tiv18fhdp46w-us-east-1"
}

# ---------------------------------------------------------------------------
# Module call
# ---------------------------------------------------------------------------

module "cf_templates_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = var.bucket_name
  aws_region  = var.aws_region
  tags        = var.tags

  server_side_encryption = var.server_side_encryption
  public_access_block    = var.public_access_block
  object_ownership       = var.object_ownership
}
