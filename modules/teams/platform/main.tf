# modules/teams/platform/main.tf

# This module acts as the registry for the Platform team's IAM roles.
# It uses the app-role-generator factory to ensure consistency and guardrails.

locals {
  team_name = "platform"
}
