# modules/identity-center/permission-sets.tf

variable "sso_instance_arn" {
  description = "The ARN of the SSO Instance"
  type        = string
}

resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdministratorAccess"
  description      = "Full access to AWS services"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

resource "aws_ssoadmin_permission_set" "readonly" {
  name             = "ReadOnlyAccess"
  description      = "Read-only access to AWS services"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

output "admin_permission_set_arn" {
  value = aws_ssoadmin_permission_set.admin.arn
}

output "readonly_permission_set_arn" {
  value = aws_ssoadmin_permission_set.readonly.arn
}
