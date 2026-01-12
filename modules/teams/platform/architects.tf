# modules/teams/platform/architects.tf

# 1. Platform Architects (Infrastructure Approval & Oversight)
data "aws_iam_policy_document" "platform_architect" {
  statement {
    sid    = "ArchitectInfrastructureRead"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "s3:Get*",
      "s3:List*",
      "rds:Describe*",
      "eks:Describe*",
      "lambda:Get*",
      "lambda:List*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ArchitectApprovalOps"
    effect = "Allow"
    actions = [
      "iam:CreatePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:DeletePolicyVersion"
    ]
    resources = ["*"] # Boundary restricted by app-role-generator
  }
}

module "platform_architect_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "platform_architects", true) ? 1 : 0

  role_name   = "${local.team_name}-architect"
  description = "Role for Platform Architects with infrastructure oversight"
  app_name    = "platform-architect"
  team        = local.team_name

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/terraform-infra-core"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.platform_architect.json

  tags = var.tags
}

# 2. Enterprise Architects (Cross-Organization Visibility)
module "enterprise_architect_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "enterprise_architects", true) ? 1 : 0

  role_name   = "enterprise-architect"
  description = "Role for Enterprise Architects with organization-wide visibility"
  app_name    = "enterprise-architect"
  team        = local.team_name

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/enterprise-standards"]

  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  tags = var.tags
}

# 3. Solution Architects (Project Specific)
module "solution_architect_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "solution_architects", true) ? 1 : 0

  role_name   = "solution-architect"
  description = "Base role for Solution Architects"
  app_name    = "solution-architect"
  team        = local.team_name

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/*"]

  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]

  tags = var.tags
}
