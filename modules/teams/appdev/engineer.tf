# modules/teams/appdev/engineer.tf

data "aws_iam_policy_document" "engineer" {
  statement {
    sid    = "S3AppDevAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::appdev-*"]
  }

  statement {
    sid    = "CloudWatchLogsAccess"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/app-*"]
  }
}

module "engineer_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "engineer", true) ? 1 : 0

  role_name   = "appdev-engineer"
  description = "Standard role for AppDev Engineers"
  app_name    = "general-dev"
  team        = "appdev"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/app-*"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.engineer.json

  tags = var.tags
}
