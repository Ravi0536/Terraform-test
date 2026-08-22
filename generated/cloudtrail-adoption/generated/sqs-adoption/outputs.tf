output "queue_id" {
  description = "URL of the adopted SQS queue (also its Terraform id)."
  value       = module.sqs_queue.queue_id
}

output "queue_arn" {
  description = "ARN of the adopted SQS queue."
  value       = module.sqs_queue.queue_arn
}

output "queue_url" {
  description = "URL of the adopted SQS queue."
  value       = module.sqs_queue.queue_url
}

output "queue_name" {
  description = "Name of the adopted SQS queue."
  value       = module.sqs_queue.queue_name
}
