import {
  to = module.sqs_queue.aws_sqs_queue.this
  id = "https://sqs.us-east-1.amazonaws.com/346589946607/tos-jira-agentic-e2e"
}

module "sqs_queue" {
  source = "./modules/sqs_queue"

  name                      = var.queue_config.name
  message_retention_seconds = var.queue_config.message_retention_seconds
  sqs_managed_sse_enabled   = var.queue_config.sqs_managed_sse_enabled
  tags                      = var.tags
}
