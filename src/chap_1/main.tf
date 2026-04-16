data "aws_caller_identity" "current" {}

module "developers_group" {
  source = "../modules/iam_groups"

  group_name  = "${local.project}-developers-${var.stage}"
  path        = "/teams/"
  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
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
