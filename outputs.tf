# Define your outputs.tf configurations here
output "ec2_instance_id" {
  description = "AWS instance id"
  value       = "${aws_instance.example.id}"
}