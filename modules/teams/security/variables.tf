# modules/teams/security/variables.tf

variable "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  type        = string
}

variable "permissions_boundary_arn" {
  description = "The ARN of the policy used as a permissions boundary"
  type        = string
}

variable "github_org" {
  description = "The GitHub organization name"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enabled_roles" {
  description = "Map of roles to enable/disable"
  type        = map(bool)
  default = {
    guardduty_agent   = true
    security_engineer = true
  }
}
