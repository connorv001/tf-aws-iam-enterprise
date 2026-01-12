# modules/teams/platform/ops-roles.tf

# 1. Cloud Data Engineers (RDS, Redshift, Glue)
data "aws_iam_policy_document" "cloud_data_engineer" {
  statement {
    sid    = "DataOpsRDS"
    effect = "Allow"
    actions = [
      "rds:Describe*",
      "rds:List*",
      "rds:ModifyDBInstance",
      "rds:RebootDBInstance"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "DataOpsGlue"
    effect = "Allow"
    actions = [
      "glue:Get*",
      "glue:List*",
      "glue:BatchGet*"
    ]
    resources = ["*"]
  }
}

module "cloud_data_engineer_role" {
  source = "../../app-role-generator"
  count  = lookup(var.enabled_roles, "cloud_data_engineers", true) ? 1 : 0

  role_name         = "${local.team_name}-data-engineer"
  description       = "Role for Cloud Data Engineers"
  app_name          = "data-ops"
  team              = local.team_name
  oidc_provider_arn = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/data-infrastructure"]
  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.cloud_data_engineer.json
  tags = var.tags
}

# 2. CloudWatch Admins
module "cloudwatch_admin_role" {
  source = "../../app-role-generator"
  count  = lookup(var.enabled_roles, "cloudwatch_admins", true) ? 1 : 0

  role_name         = "${local.team_name}-cloudwatch-admin"
  description       = "Administrative role for CloudWatch and Logs"
  app_name          = "cloudwatch-admin"
  team              = local.team_name
  oidc_provider_arn = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/monitoring-config"]
  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = ["arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
  tags = var.tags
}

# 3. Network Engineers
data "aws_iam_policy_document" "network_engineer" {
  statement {
    sid    = "NetworkOps"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:*Vpc*",
      "ec2:*Subnet*",
      "ec2:*Gateway*",
      "ec2:*RouteTable*",
      "ec2:*TransitGateway*",
      "directconnect:*"
    ]
    resources = ["*"]
  }
}

module "network_engineer_role" {
  source = "../../app-role-generator"
  count  = lookup(var.enabled_roles, "network_engineers", true) ? 1 : 0

  role_name         = "${local.team_name}-network-engineer"
  description       = "Role for Network Engineers"
  app_name          = "network-ops"
  team              = local.team_name
  oidc_provider_arn = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/network-infrastructure"]
  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.network_engineer.json
  tags = var.tags
}

# 4. Security Engineers
module "security_engineer_role" {
  source = "../../app-role-generator"
  count  = lookup(var.enabled_roles, "security_engineers", true) ? 1 : 0

  role_name         = "${local.team_name}-security-engineer"
  description       = "Role for Security Engineers"
  app_name          = "security-ops"
  team              = local.team_name
  oidc_provider_arn = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/security-automation"]
  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess",
    "arn:aws:iam::aws:policy/AWSSecurityHubFullAccess"
  ]
  tags = var.tags
}

# 5. Instance Scheduler (Service Role)
module "instance_scheduler_role" {
  source = "../../app-role-generator"
  count  = lookup(var.enabled_roles, "instance_scheduler", true) ? 1 : 0

  role_name         = "${local.team_name}-instance-scheduler"
  description       = "Service role for AWS Instance Scheduler"
  app_name          = "instance-scheduler"
  team              = local.team_name
  oidc_provider_arn = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/instance-scheduler-config"]
  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = ["arn:aws:iam::aws:policy/service-role/AWSInstanceSchedulerServiceRolePolicy"]
  tags = var.tags
}
