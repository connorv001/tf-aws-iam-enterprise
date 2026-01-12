# modules/teams/sre/lead.tf

data "aws_iam_policy_document" "sre_lead" {
  statement {
    sid    = "SRELeadAdmin"
    effect = "Allow"
    actions = [
      "ec2:*",
      "rds:*",
      "cloudwatch:*",
      "autoscaling:*"
    ]
    resources = ["*"]
  }
}

module "sre_lead_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "lead", true) ? 1 : 0

  role_name   = "sre-lead"
  description = "Elevated role for SRE Leads"
  app_name    = "reliability-lead"
  team        = "sre"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/sre-infra-core"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.sre_lead.json

  tags = var.tags
}
