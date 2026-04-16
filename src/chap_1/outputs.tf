output "s3_data_bucket" {
  description = "S3 data bucket name for the current stage"
  value       = lookup(local.env[var.stage], "s3_data_bucket", "default-bucket")
}

output "s3_secure_data_bucket" {
  description = "S3 secure data bucket name for the current stage"
  value       = lookup(local.env[var.stage], "s3_secure_data_bucket", "default-secure-bucket")
}

output "log_level" {
  description = "Log level for the current stage"
  value       = lookup(local.env[var.stage], "log_level", "INFO")
}

output "database" {
  description = "Database name for the current stage"
  value       = lookup(local.env[var.stage], "database", "default-db")
}

output "current_stage" {
  description = "Current deployment stage"
  value       = var.stage
}

output "account_id" {
  description = "AWS Account ID"
  value       = local.account_id
}

output "project_name" {
  description = "Project name"
  value       = local.project
}

output "developer_user_arn" {
  description = "ARN of the developer IAM user"
  value       = module.developer_user.user_arn
}

output "admin_user_arn" {
  description = "ARN of the admin IAM user"
  value       = module.admin_user.user_arn
}

output "developers_group_arn" {
  description = "ARN of the developers IAM group"
  value       = module.developers_group.group_arn
}

output "administrators_group_arn" {
  description = "ARN of the administrators IAM group"
  value       = module.administrators_group.group_arn
}

output "s3_read_policy_arn" {
  description = "ARN of the S3 read policy"
  value       = module.s3_read_policy.policy_arn
}

output "lambda_execution_policy_arn" {
  description = "ARN of the Lambda execution policy"
  value       = module.lambda_execution_policy.policy_arn
}
