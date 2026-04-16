resource "aws_iam_user" "this" {
  name = var.user_name
  path = var.path
  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = toset(var.policy_arns)

  user       = aws_iam_user.this.name
  policy_arn = each.value
}
