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
    module.s3_read_policy.policy_arn,
    module.terraform_state_backend_policy.policy_arn
  ]
  users = []
}

module "administrators_group" {
  source = "../modules/iam_groups"

  group_name = "${local.project}-administrators-${var.stage}"
  path       = "/${local.project}-teams/"
  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    module.terraform_state_backend_policy.policy_arn
  ]
  users = []
}

module "deny_iam_privilege_escalation_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-deny-iam-escalation-${var.stage}"
  path        = "/${local.project}_policies/"
  description = "Deny IAM privilege escalation actions"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Action = [
          "iam:PassRole",
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:UpdateAssumeRolePolicy"
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

module "developer_user" {
  source = "../modules/iam_users"

  user_name         = "${local.project}-developer-${var.stage}"
  path              = "/${local.project}-users/"
  create_access_key = true
  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    module.deny_iam_privilege_escalation_policy.policy_arn
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
  ]
  tags = {
    Environment = var.stage
    Project     = local.project
    Role        = "Administrator"
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

module "terraform_state_backend_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-terraform-state-backend-${var.stage}"
  path        = "/${local.project}_policies/"
  description = "Permissions for terraform state backend access"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
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

module "terraform_plan_role" {
  source = "../modules/iam_roles"

  role_name   = "${local.project}-terraform-plan-${var.stage}"
  path        = "/${local.project}-roles/"
  description = "Shared role for engineers to run terraform plan"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "${local.project}-engineers"
          }
        }
      }
    ]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    module.terraform_state_backend_policy.policy_arn,
    module.deny_iam_privilege_escalation_policy.policy_arn
  ]
  tags = {
    Environment = var.stage
    Project     = local.project
    Purpose     = "Terraform Plan Operations"
  }
}
