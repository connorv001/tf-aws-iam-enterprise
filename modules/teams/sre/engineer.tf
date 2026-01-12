# modules/teams/sre/engineer.tf

data "aws_iam_policy_document" "sre_engineer" {
  statement {
    sid    = "SREReadOnly"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "rds:Describe*",
      "lambda:List*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

module "sre_engineer_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "engineer", true) ? 1 : 0

  role_name   = "sre-engineer"
  description = "Standard role for SRE Engineers"
  app_name    = "reliability"
  team        = "sre"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/sre-tooling"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.sre_engineer.json

  tags = var.tags
}
