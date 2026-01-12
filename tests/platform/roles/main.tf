module "platform_roles" {
  source = "../../../modules/teams/platform"

  oidc_provider_arn        = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
  permissions_boundary_arn = "arn:aws:iam::123456789012:policy/boundary"
  github_org               = "my-org"
  
  tags = {
    Environment = "Test"
    Team        = "Platform"
  }
}

output "role_arns" {
  value = {
    engineer             = module.platform_roles.platform_engineer_role_arn
    platform_architect   = module.platform_roles.platform_architect_role_arn
    enterprise_architect = module.platform_roles.enterprise_architect_role_arn
    solution_architect   = module.platform_roles.solution_architect_role_arn
  }
}
