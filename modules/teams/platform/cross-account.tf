# modules/teams/platform/cross-account.tf

# 1. Spoke Account Assumed Role
# This role is meant to be deployed in Spoke accounts and assumed by Hub account Platform Engineers.
data "aws_iam_policy_document" "spoke_admin_trust" {
  count = var.hub_account_id != "" ? 1 : 0
  statement {
    sid    = "AllowHubPlatformEngineers"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.hub_account_id}:root"]
    }
    # Optional: Require MFA for cross-account assume
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "spoke_platform_admin" {
  count              = var.hub_account_id != "" ? 1 : 0
  name               = "${local.team_name}-spoke-admin"
  assume_role_policy = data.aws_iam_policy_document.spoke_admin_trust[0].json
  
  permissions_boundary = var.permissions_boundary_arn
  
  tags = merge(var.tags, {
    AccountRole = "Spoke"
  })
}

resource "aws_iam_role_policy_attachment" "spoke_platform_admin_managed" {
  count      = var.hub_account_id != "" ? 1 : 0
  role       = aws_iam_role.spoke_platform_admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Or more restricted
}

# 2. Hub Account Permissions to Assume Spoke Roles
data "aws_iam_policy_document" "hub_assume_spoke" {
  count = length(var.spoke_account_ids) > 0 ? 1 : 0
  statement {
    sid    = "AllowAssumeSpokeRoles"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [for id in var.spoke_account_ids : "arn:aws:iam::${id}:role/${local.team_name}-spoke-admin"]
  }
}

resource "aws_iam_policy" "hub_assume_spoke" {
  count  = length(var.spoke_account_ids) > 0 ? 1 : 0
  name   = "platform-hub-assume-spoke"
  policy = data.aws_iam_policy_document.hub_assume_spoke[0].json
}

# Attach this policy to the Platform Engineer role in the Hub account
resource "aws_iam_role_policy_attachment" "platform_engineer_assume_spoke" {
  count      = (length(var.spoke_account_ids) > 0 && length(module.platform_engineer_role) > 0) ? 1 : 0
  role       = module.platform_engineer_role[0].role_name
  policy_arn = aws_iam_policy.hub_assume_spoke[0].arn
}
