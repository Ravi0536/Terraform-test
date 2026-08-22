resource "aws_sqs_queue" "tos_jira_agentic_e2e" {
  name                      = "tos-jira-agentic-e2e"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
  tags = {
    lane_drift_probe = "0822b"
  }
}
