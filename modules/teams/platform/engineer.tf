# modules/teams/platform/engineer.tf

# 1. Define the policy for Platform Engineers (Network & Infrastructure management).
data "aws_iam_policy_document" "platform_admin" {
  statement {
    sid    = "PlatformNetworkManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateVpc*",
      "ec2:DeleteVpc*",
      "ec2:ModifyVpc*",
      "ec2:DescribeVpcs",
      "ec2:CreateSubnet*",
      "ec2:DeleteSubnet*",
      "ec2:DescribeSubnets",
      "ec2:CreateSecurityGroup*",
      "ec2:DeleteSecurityGroup*",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroup*",
      "ec2:RevokeSecurityGroup*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "PlatformS3Management"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutBucket*",
      "s3:GetBucket*"
    ]
    resources = ["*"]
  }
}

# 2. Instantiate the app-role-generator factory.
module "platform_engineer_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "engineer", true) ? 1 : 0

  role_name   = "${local.team_name}-engineer"
  description = "Role for Platform Engineers to manage shared infrastructure"
  app_name    = "platform-admin"
  team        = local.team_name

  oidc_provider_arn = var.oidc_provider_arn
  # Allow the central infra repo to assume this role
  github_repositories = ["${var.github_org}/terraform-infra-core"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.platform_admin.json

  tags = var.tags
}
