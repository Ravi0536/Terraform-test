resource "aws_iam_role" "main" {
  name                 = var.name
  assume_role_policy   = var.assume_role_policy
  description          = var.description
  path                 = var.path
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}
