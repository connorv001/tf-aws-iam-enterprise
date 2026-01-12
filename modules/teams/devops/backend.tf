# modules/teams/devops/backend.tf

# 1. Define the policy for generic backend services (ECS/Lambda deployment).
data "aws_iam_policy_document" "backend_deployer" {
  statement {
    sid    = "ECSDeployment"
    effect = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition"
    ]
    resources = ["*"] # Ideally restricted via resource tags or names
  }

  statement {
    sid    = "ECRReadOnly"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "LoggingAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/backend-*"]
  }
}

# 2. Instantiate the app-role-generator factory.
module "backend_service_role" {
  source = "../../app-role-generator"

  count = lookup(var.enabled_roles, "backend", true) ? 1 : 0

  role_name   = "${local.team_name}-backend-service"
  description = "Role for deploying and running backend services"
  app_name    = "backend-service"
  team        = local.team_name

  oidc_provider_arn = var.oidc_provider_arn
  # Allow the backend microservices repos to assume this role
  github_repositories = ["${var.github_org}/backend-api", "${var.github_org}/worker-service"]

  permissions_boundary_arn = var.permissions_boundary_arn
  inline_policy            = data.aws_iam_policy_document.backend_deployer.json

  tags = var.tags
}
