resource "aws_iam_group" "this" {
  name = var.group_name
  path = var.path
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = toset(var.policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = each.value
}

resource "aws_iam_group_membership" "this" {
  count = length(var.users) > 0 ? 1 : 0

  name  = "${var.group_name}-membership"
  group = aws_iam_group.this.name
  users = var.users
}
