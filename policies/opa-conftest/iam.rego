package main

# 1. No Wildcard Principals in Trust Policies
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_role"
    
    # Check if assume_role_policy contains a wildcard principal
    policy := json.unmarshal(resource.change.after.assume_role_policy)
    statement := policy.Statement[_]
    statement.Principal.AWS == "*"
    
    msg := sprintf("IAM role '%v' has a wildcard principal in its trust policy. This is forbidden.", [resource.name])
}

# 2. Require Permission Boundary for App Roles
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_role"
    
    # Check if this is an app role (naming convention check or similar)
    # For now, let's assume all non-foundation roles should have one
    not resource.change.after.permissions_boundary
    
    msg := sprintf("IAM role '%v' is missing a permissions boundary. All application roles must have one.", [resource.name])
}

# 3. No IAM Users with Access Keys (Force Roles/OIDC)
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_access_key"
    
    msg := sprintf("IAM Access Key found for resource '%v'. Long-lived credentials are forbidden. Use OIDC or IAM Roles instead.", [resource.name])
}

# 4. Require Tags for All Roles
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_role"
    
    count(resource.change.after.tags) == 0
    
    msg := sprintf("IAM role '%v' is missing tags. All roles must be tagged with environment and team.", [resource.name])
}

# 5. Require Managed Policy or Inline Policy (No empty roles)
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_iam_role"
    
    not resource.change.after.managed_policy_arns
    not resource.change.after.inline_policy
    
    msg := sprintf("IAM role '%v' has no attached policies. Roles should be functional or deleted.", [resource.name])
}
