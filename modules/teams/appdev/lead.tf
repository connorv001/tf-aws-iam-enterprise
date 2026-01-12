# modules/teams/appdev/lead.tf

data "aws_iam_policy_document" "lead" {
  statement {
    sid    = "LeadElevatedAccess"
    effect = "Allow"
    actions = [
      "s3:*",
      "lambda:*",
      "dynamodb:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Team"
      values   = ["appdev"]
    }
  }
}

module "lead_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "lead", true) ? 1 : 0

  role_name   = "appdev-lead"
  description = "Elevated role for AppDev Leads"
  app_name    = "lead-dev"
  team        = "appdev"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/app-infra"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.lead.json

  tags = var.tags
}
