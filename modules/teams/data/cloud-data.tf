# modules/teams/data/cloud-data.tf

data "aws_iam_policy_document" "cloud_data" {
  statement {
    sid    = "DataBucketAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::data-lake-*"]
  }

  statement {
    sid    = "AthenaAccess"
    effect = "Allow"
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults"
    ]
    resources = ["*"]
  }
}

module "cloud_data_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "cloud_data", true) ? 1 : 0

  role_name   = "cloud-data-engineer"
  description = "Role for Cloud Data Engineers"
  app_name    = "data-pipeline"
  team        = "data"

  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["${var.github_org}/data-jobs"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.cloud_data.json

  tags = var.tags
}
