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
    cloud_data_engineer  = module.platform_roles.cloud_data_engineer_role_arn
    cloudwatch_admin     = module.platform_roles.cloudwatch_admin_role_arn
    network_engineer     = module.platform_roles.network_engineer_role_arn
    security_engineer    = module.platform_roles.security_engineer_role_arn
    instance_scheduler   = module.platform_roles.instance_scheduler_role_arn
  }
}
