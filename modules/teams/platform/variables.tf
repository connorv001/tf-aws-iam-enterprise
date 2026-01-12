# modules/teams/platform/variables.tf

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
    datadog               = true
    engineer              = true
    platform_architects   = true
    enterprise_architects  = true
    solution_architects   = true
    cloud_data_engineers  = true
    cloudwatch_admins     = true
    network_engineers     = true
    security_engineers    = true
    instance_scheduler    = true
  }
}

variable "hub_account_id" {
  description = "The AWS Account ID of the Hub account"
  type        = string
  default     = ""
}

variable "spoke_account_ids" {
  description = "List of AWS Account IDs for Spoke accounts"
  type        = list(string)
  default     = []
}


variable "breakglass_approvers" {
  description = "List of GitHub repositories allowed to trigger breakglass"
  type        = list(string)
  default     = []
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for security alerts"
  type        = string
  default     = ""
}
