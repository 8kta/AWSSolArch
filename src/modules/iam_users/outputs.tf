output "user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.this.name
}

output "user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.this.arn
}

output "user_unique_id" {
  description = "Unique ID of the IAM user"
  value       = aws_iam_user.this.unique_id
}
