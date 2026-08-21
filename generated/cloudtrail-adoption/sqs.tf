resource "aws_sqs_queue" "shipment_notify" {
  name                       = "shipment-notify"
  visibility_timeout_seconds = 240

  tags = {
    drift_source = "nrt-e2e"
  }
}

resource "aws_sqs_queue" "tos_lane_jira_0821101942" {
  name = "tos-lane-jira-0821101942"
  tags = {
    lane_run   = "0821101942"
    managed_by = "tos"
  }
}

resource "aws_sqs_queue" "tos_jira_agentic_e2e" {
  name                      = "tos-jira-agentic-e2e"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
  tags = {
    lane_drift_probe = "0821b"
  }
}

import {
  to = aws_sqs_queue.tos_jira_agentic_e2e
  id = "https://sqs.us-east-1.amazonaws.com/346589946607/tos-jira-agentic-e2e"
}
