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

output "access_key_id" {
  description = "Access key ID for the IAM user"
  value       = var.create_access_key ? aws_iam_access_key.this[0].id : null
}

output "access_key_secret" {
  description = "Access key secret for the IAM user (sensitive)"
  value       = var.create_access_key ? aws_iam_access_key.this[0].secret : null
  sensitive   = true
}
