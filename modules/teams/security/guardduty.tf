# modules/teams/security/guardduty.tf

data "aws_iam_policy_document" "guardduty_readonly" {
  statement {
    sid    = "GuardDutyReadOnly"
    effect = "Allow"
    actions = [
      "guardduty:Get*",
      "guardduty:List*",
      "guardduty:Describe*"
    ]
    resources = ["*"]
  }
}

module "guardduty_agent_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "guardduty_agent", true) ? 1 : 0

  role_name   = "guardduty-agent"
  description = "Role for GuardDuty security auditing"
  app_name    = "guardduty"
  team        = "security"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/security-audits"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.guardduty_readonly.json

  tags = var.tags
}
