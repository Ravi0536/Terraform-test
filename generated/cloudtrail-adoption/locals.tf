# ---------------------------------------------------------------------------
# locals.tf — derived values
# ---------------------------------------------------------------------------

locals {
  # Convenience: full resource address for use in outputs / descriptions.
  queue_display_name = "SQS Queue: ${aws_sqs_queue.tos_extensibility_proof.name}"
}
