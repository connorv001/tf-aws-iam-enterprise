# modules/app-role-generator/role.tf

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.description
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  permissions_boundary = var.permissions_boundary_arn

  tags = merge(
    var.tags,
    {
      "Team"        = var.team
      "Application" = var.app_name
    }
  )
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy != null ? 1 : 0
  name   = "app-permissions"
  role   = aws_iam_role.this.id
  policy = var.inline_policy
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}
