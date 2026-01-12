# modules/teams/devops/engineer.tf

# 1. Define the policy for DevOps Engineers (General application operations).
data "aws_iam_policy_document" "devops_operator" {
  statement {
    sid    = "ApplicationOperations"
    effect = "Allow"
    actions = [
      "ecs:List*",
      "ecs:Describe*",
      "lambda:List*",
      "lambda:Get*",
      "rds:List*",
      "rds:Describe*",
      "s3:List*",
      "s3:Get*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "TroubleshootingLogs"
    effect = "Allow"
    actions = [
      "logs:Get*",
      "logs:List*",
      "logs:Describe*",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

# 2. Instantiate the app-role-generator factory.
module "devops_engineer_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "engineer", true) ? 1 : 0

  role_name   = "${local.team_name}-engineer"
  description = "Role for DevOps engineers to monitor and operate applications"
  app_name    = "devops-admin"
  team        = local.team_name

  oidc_provider_arn = var.oidc_provider_arn
  # Allow the internal admin tools or specific operator repos
  github_repositories = ["${var.github_org}/devops-tooling"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.devops_operator.json

  tags = var.tags
}
