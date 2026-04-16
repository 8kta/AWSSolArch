locals {
  account_id         = data.aws_caller_identity.current.account_id
  us_east_aws_region = "us-east-1"

  project = "awssolarch"
  runtime = "python3.12"

  env = {
    dev = {
      s3_data_bucket        = "octavalo-data-dev"
      s3_secure_data_bucket = "octavalo-secure-data-dev"
      stage                 = "dev"
      log_level             = "WARN"
      database              = "octavalo"
    }
    qa = {
      s3_data_bucket        = "octavalo-data-qa"
      s3_secure_data_bucket = "octavalo-secure-data-qa"
      stage                 = "qa"
      log_level             = "WARN"
      database              = "octavalo_qa"
    }
    prod = {
      s3_data_bucket        = "octavalo-data-prod"
      s3_secure_data_bucket = "octavalo-secure-data-prod"
      stage                 = "prod"
      log_level             = "WARN"
      database              = "octavalo"
    }
  }


  roles = {
    lambda       = "arn:aws:iam::${local.account_id}:role/octavalo-${local.project}-octavalo-lambda-${var.stage}"
    stepfunction = "arn:aws:iam::${local.account_id}:role/octavalo-${local.project}-octavalo-stepfunction-${var.stage}"
    cloudwatch   = "arn:aws:iam::${local.account_id}:role/octavalo-${local.project}-octavalo-cloudwatch-${var.stage}"
  }
}

variable "stage" {
  type        = string
  description = "The environment (stage) that you wish to deploy to"
  default     = "dev"
  validation {
    condition     = contains(["tmp", "sb", "dev", "qa", "stage", "prod"], var.stage)
    error_message = "Invalid 'stage', unable to deploy. Valid values are: ['tmp', 'sb', 'dev', 'qa', 'stage', 'prod']."
  }
}