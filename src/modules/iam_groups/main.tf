resource "aws_iam_group" "this" {
  name = var.group_name
  path = var.path
}

resource "aws_iam_group_policy_attachment" "this" {
  count = length(var.policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_group_membership" "this" {
  count = length(var.users) > 0 ? 1 : 0

  name  = "${var.group_name}-membership"
  group = aws_iam_group.this.name
  users = var.users
}
