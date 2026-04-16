output "group_name" {
  description = "Name of the IAM group"
  value       = aws_iam_group.this.name
}

output "group_arn" {
  description = "ARN of the IAM group"
  value       = aws_iam_group.this.arn
}

output "group_id" {
  description = "ID of the IAM group"
  value       = aws_iam_group.this.id
}

output "group_unique_id" {
  description = "Unique ID of the IAM group"
  value       = aws_iam_group.this.unique_id
}
