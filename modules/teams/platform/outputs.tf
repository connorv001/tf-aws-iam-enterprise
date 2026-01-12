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

output "cloud_data_engineer_role_arn" {
  description = "The ARN of the cloud data engineer role"
  value       = try(module.cloud_data_engineer_role[0].role_arn, "")
}

output "cloudwatch_admin_role_arn" {
  description = "The ARN of the cloudwatch admin role"
  value       = try(module.cloudwatch_admin_role[0].role_arn, "")
}

output "network_engineer_role_arn" {
  description = "The ARN of the network engineer role"
  value       = try(module.network_engineer_role[0].role_arn, "")
}

output "security_engineer_role_arn" {
  description = "The ARN of the security engineer role"
  value       = try(module.security_engineer_role[0].role_arn, "")
}

output "instance_scheduler_role_arn" {
  description = "The ARN of the instance scheduler role"
  value       = try(module.instance_scheduler_role[0].role_arn, "")
}
