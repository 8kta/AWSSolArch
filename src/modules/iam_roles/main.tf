resource "aws_iam_role" "this" {
  name               = var.role_name
  path               = var.path
  description        = var.description
  assume_role_policy = var.assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name
  path = var.path
  tags = var.tags
}
