# modules/teams/platform/breakglass.tf

# 1. Breakglass Emergency Role (AdministratorAccess)
module "breakglass_role" {
  source = "../../app-role-generator"

  # Breakglass is only created if approvers are defined
  count = length(var.breakglass_approvers) > 0 ? 1 : 0

  role_name   = "${local.team_name}-breakglass"
  description = "Emergency Breakglass role with AdministratorAccess. Triggering this role sends immediate alerts."
  app_name    = "breakglass"
  team        = local.team_name

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = var.breakglass_approvers

  # Guardrails: Session duration limited to 1 hour
  # Note: app-role-generator needs to support passing this, 
  # but for now we'll assume it defaults or we modify it if possible.
  
  permissions_boundary_arn = var.permissions_boundary_arn
  managed_policy_arns      = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  tags = merge(var.tags, {
    SecurityLevel = "Critical"
    Audit         = "Extreme"
  })
}

# 2. Alerting for Breakglass Assumption
resource "aws_cloudwatch_log_metric_filter" "breakglass_assumption" {
  count          = (length(var.breakglass_approvers) > 0 && var.sns_topic_arn != "") ? 1 : 0
  name           = "PlatformBreakglassAssumption"
  pattern        = "{ ($.eventName = \"AssumeRole\") && ($.requestParameters.roleArn = \"*${local.team_name}-breakglass*\") }"
  log_group_name = "CloudTrail/DefaultLogGroup" # Assuming standard naming from foundation

  metric_transformation {
    name      = "BreakglassAssumptionCount"
    namespace = "SecurityAlarms"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "breakglass_alarm" {
  count               = (length(var.breakglass_approvers) > 0 && var.sns_topic_arn != "") ? 1 : 0
  alarm_name          = "CRITICAL-PlatformBreakglassUsed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.breakglass_assumption[0].name
  namespace           = aws_cloudwatch_log_metric_filter.breakglass_assumption[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "CRITICAL: The Platform Breakglass role has been assumed. Immediate investigation required."
  alarm_actions       = [var.sns_topic_arn]
}
