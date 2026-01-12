module "password_policy" {
  source = "../../../modules/foundation/iam-password-policy"

  # Testing variable overrides (optional)
  minimum_password_length = 14
}

output "policy_arn" {
  value = "arn:aws:iam::aws:policy/AccountPasswordPolicy" # Pseudo-ARN, as this resource doesn't export an ARN usually
}
