# ---------------------------------------------------------------------------
# outputs.tf — key attributes exposed at the root (alphabetical)
# ---------------------------------------------------------------------------

output "queue_arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.tos_extensibility_proof.arn
}

output "queue_id" {
  description = "URL of the SQS queue (same as queue_url)."
  value       = aws_sqs_queue.tos_extensibility_proof.id
}

output "queue_name" {
  description = "Name of the SQS queue."
  value       = aws_sqs_queue.tos_extensibility_proof.name
}

output "queue_url" {
  description = "URL of the SQS queue."
  value       = aws_sqs_queue.tos_extensibility_proof.url
}
