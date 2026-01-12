# modules/identity-center/assignments.tf

variable "assignments" {
  description = "Map of account assignments: account_id -> { group_name -> permission_set_arn }"
  type        = map(map(string))
  default     = {}
}

# This is a conceptual representation of how assignments would look.
# In a real environment, you would use data sources to find group IDs.

/*
resource "aws_ssoadmin_account_assignment" "example" {
  for_each = var.assignments

  instance_arn       = var.sso_instance_arn
  permission_set_arn = each.value.permission_set_arn
  principal_id       = each.value.group_id
  principal_type     = "GROUP"

  target_id   = each.key
  target_type = "AWS_ACCOUNT"
}
*/
