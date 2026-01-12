variable "sns_topic_arn" {
  description = "SNS topic ARN for security notifications"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name for CloudTrail logs"
  type        = string
}

# 1. Failed AssumeRole Alarm
resource "aws_cloudwatch_log_metric_filter" "failed_assume_role" {
  name           = "FailedAssumeRole"
  pattern        = "{ ($.eventName = \"AssumeRole\") && ($.errorCode = \"*UnauthorizedOperation\" || $.errorCode = \"AccessDenied\") }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "FailedAssumeRoleCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "failed_assume_role" {
  alarm_name          = "FailedAssumeRoleAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.failed_assume_role.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.failed_assume_role.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when a failed AssumeRole event is detected."
  alarm_actions       = [var.sns_topic_arn]
}

# 2. IAM Policy Change Alarm
resource "aws_cloudwatch_log_metric_filter" "iam_policy_change" {
  name           = "IAMPolicyChange"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=SetDefaultPolicyVersion)}"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "IAMPolicyChangeCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_policy_change" {
  alarm_name          = "IAMPolicyChangeAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.iam_policy_change.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.iam_policy_change.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when an IAM policy change is detected."
  alarm_actions       = [var.sns_topic_arn]
}

# 3. Root Account Usage Alarm
resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  name           = "RootAccountUsage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "RootAccountUsageCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage" {
  alarm_name          = "RootAccountUsageAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.root_usage.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.root_usage.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when root account usage is detected."
  alarm_actions       = [var.sns_topic_arn]
}
