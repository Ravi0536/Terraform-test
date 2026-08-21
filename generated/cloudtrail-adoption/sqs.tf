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

resource "aws_sqs_queue" "tos_lane_jira_0821193034" {
  name = "tos-lane-jira-0821193034"
  tags = {
    lane_run   = "0821193034"
    managed_by = "tos"
  }
}
