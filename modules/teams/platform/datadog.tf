# modules/teams/platform/datadog.tf

# 1. Define the least-privilege policy for Datadog integration.
# Following AWS and Datadog best practices for read-only monitoring.
data "aws_iam_policy_document" "datadog_readonly" {
  statement {
    sid    = "DatadogReadMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "ec2:Describe*",
      "rds:Describe*",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "DatadogReadLogs"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

# 2. Instantiate the app-role-generator factory.
module "datadog_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "datadog", true) ? 1 : 0

  role_name   = "${local.team_name}-datadog-integration"
  description = "Role for Datadog integration to collect metrics and logs"
  app_name    = "datadog"
  team        = local.team_name

  oidc_provider_arn = var.oidc_provider_arn
  # Allow Datadog's integration repo to assume this role
  github_repositories = ["${var.github_org}/infrastructure-monitoring"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.datadog_readonly.json

  tags = var.tags
}
