data "aws_caller_identity" "current" {}

module "s3_read_policy" {
  source = "../modules/iam_policies"

  policy_name = "${local.project}-s3-read-${var.stage}"
  path        = "/policies/"
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
  path        = "/policies/"
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

  group_name  = "${local.project}-developers-${var.stage}"
  path        = "/teams/"
  policy_arns = [
    module.s3_read_policy.policy_arn
  ]
  users = []
}

module "administrators_group" {
  source = "../modules/iam_groups"

  group_name  = "${local.project}-administrators-${var.stage}"
  path        = "/teams/"
  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  users = []
}
