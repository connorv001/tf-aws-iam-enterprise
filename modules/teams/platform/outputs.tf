# modules/teams/platform/outputs.tf

output "platform_engineer_role_arn" {
  description = "The ARN of the platform engineer role"
  value       = try(module.platform_engineer_role[0].role_arn, "")
}

output "platform_architect_role_arn" {
  description = "The ARN of the platform architect role"
  value       = try(module.platform_architect_role[0].role_arn, "")
}

output "enterprise_architect_role_arn" {
  description = "The ARN of the enterprise architect role"
  value       = try(module.enterprise_architect_role[0].role_arn, "")
}

output "solution_architect_role_arn" {
  description = "The ARN of the solution_architect role"
  value       = try(module.solution_architect_role[0].role_arn, "")
}
