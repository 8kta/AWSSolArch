data "aws_caller_identity" "current" {}

module "s3_read_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-s3-read-${var.stage}"
  path        = "/${local.project}_policies/"
  description = "Policy for reading S3 buckets"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.env[var.stage].s3_data_bucket}",
          "arn:aws:s3:::${local.env[var.stage].s3_data_bucket}/*"
        ]
      }
    ]
  })
  tags = {
    Environment = var.stage
    Project     = local.project
  }
}

module "lambda_execution_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-lambda-execution-${var.stage}"
  path        = "/${local.project}-policies/"
  description = "Policy for Lambda function execution"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${local.us_east_aws_region}:${local.account_id}:log-group:/aws/lambda/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${local.env[var.stage].s3_data_bucket}/*"
        ]
      }
    ]
  })
  tags = {
    Environment = var.stage
    Project     = local.project
  }
}

module "developers_group" {
  source = "../modules/iam_groups"

  group_name = "${local.project}-developers-${var.stage}"
  path       = "/${local.project}-teams/"
  policy_arns = [
    module.s3_read_policy.policy_arn
  ]
  users = []
}

module "administrators_group" {
  source = "../modules/iam_groups"

  group_name = "${local.project}-administrators-${var.stage}"
  path       = "/${local.project}-teams/"
  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  users = []
}

module "developer_user" {
  source = "../modules/iam_users"

  user_name         = "${local.project}-developer-${var.stage}"
  path              = "/${local.project}-users/"
  create_access_key = true
  policy_arns = [
    module.s3_read_policy.policy_arn,
    module.deny_terraform_apply_policy.policy_arn
  ]
  tags = {
    Environment = var.stage
    Project     = local.project
    Role        = "Developer"
  }
}

module "admin_user" {
  source = "../modules/iam_users"

  user_name         = "${local.project}-admin-${var.stage}"
  path              = "/${local.project}-users/"
  create_access_key = true
  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    module.deny_terraform_apply_policy.policy_arn
  ]
  tags = {
    Environment = var.stage
    Project     = local.project
    Role        = "Administrator"
  }
}

module "deny_terraform_apply_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-deny-terraform-apply-${var.stage}"
  path        = "/${local.project}_policies/"
  description = "Policy to deny resource creation and modification (prevents terraform apply)"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Action = [
          "*:Create*",
          "*:Delete*",
          "*:Update*",
          "*:Put*",
          "*:Modify*",
          "*:Attach*",
          "*:Detach*"
        ]
        Resource = "*"
      }
    ]
  })
  tags = {
    Environment = var.stage
    Project     = local.project
  }
}

module "secure_bucket_read_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-secure-bucket-read-${var.stage}"
  path        = "/${local.project}_policies/"
  description = "Policy for read-only access to secure S3 bucket"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.env[var.stage].s3_secure_data_bucket}",
          "arn:aws:s3:::${local.env[var.stage].s3_secure_data_bucket}/*"
        ]
      }
    ]
  })
  tags = {
    Environment = var.stage
    Project     = local.project
  }
}

module "ec2_secure_bucket_role" {
  source = "../modules/iam_roles"

  role_name   = "${local.project}-ec2-secure-bucket-${var.stage}"
  path        = "/${local.project}-roles/"
  description = "Role for EC2 instances to read from secure bucket"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  policy_arns = [
    module.secure_bucket_read_policy.policy_arn
  ]
  create_instance_profile = true
  tags = {
    Environment = var.stage
    Project     = local.project
    Purpose     = "EC2 Secure Bucket Read Access"
  }
}
