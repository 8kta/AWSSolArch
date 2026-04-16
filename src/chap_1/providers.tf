terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.62"
    }
    
  }
  required_version = ">= 1.9.2"
  backend "s3" {
    key    = "terraform/spark-fbomb/terraform.tfstate"
    bucket = "octavalo-data-dev"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
  default_tags {
    tags = {
      STAGE          = var.stage
      octavalo_app        = "AnalyticsCOE Cloud Apps"
      octavalo_ownerEmail = "alonsog.gascon@gmail.com"
      octavalo_project    = "AWSSolArch"
      octavalo_teamName   = "octavalo-team"
      octavalo_env        = var.stage
      component      = "code"
      deployed_by    = "terraform"
      github_url  = "https://github.com/8kta/AWSSolArch"
      jenkins_url    = "tbd"
    }
  }
}


