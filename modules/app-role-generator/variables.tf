# modules/app-role-generator/variables.tf

variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "description" {
  description = "The description of the IAM role"
  type        = string
  default     = "Managed by App Role Generator"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "team" {
  description = "The team owning the application"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  type        = string
}

variable "github_repositories" {
  description = "List of GitHub repositories allowed to assume this role (format: org/repo)"
  type        = list(string)
}

variable "permissions_boundary_arn" {
  description = "The ARN of the policy used as a permissions boundary"
  type        = string
  default     = null
}

variable "inline_policy" {
  description = "The JSON policy document to attach as an inline policy"
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
