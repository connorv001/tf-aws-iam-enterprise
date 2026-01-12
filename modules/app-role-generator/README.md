# App Role Generator Module

**The Core Factory for Secure IAM Roles.**

---

## 📖 Overview

This module is the heart of the `tf-aws-iam-enterprise` framework. It abstracts away the complexity of creating secure IAM roles, ensuring that every role follows organizational standards by default.

### Key Features
- **OIDC Native:** Automatically generates Trust Policies for GitHub repositories.
- **Guardrails:** Enforces `permissions_boundary` on every role.
- **Standardization:** Enforces consistent tagging and naming conventions.

---

## 🛠 Usage

```hcl
module "app_role" {
  source = "./modules/app-role-generator"

  # Naming & Metadata
  role_name   = "my-app-role"
  app_name    = "my-app"
  team        = "devops"
  description = "Deployment role for My App"

  # Identity (Who can assume this?)
  oidc_provider_arn   = var.oidc_provider_arn
  github_repositories = ["my-org/my-repo"]

  # Guardrails (What are the max limits?)
  permissions_boundary_arn = "arn:aws:iam::123456789012:policy/boundary/PowerUserBoundary"

  # Permissions (What can it actually do?)
  inline_policy = data.aws_iam_policy_document.my_policy.json
}
```

---

## 📥 Inputs

| Name | Type | Description | Required |
|------|------|-------------|:--------:|
| `role_name` | `string` | The physical name of the IAM role. | Yes |
| `app_name` | `string` | Logical name of the application (for tagging). | Yes |
| `team` | `string` | Team owning the role (for tagging). | Yes |
| `oidc_provider_arn` | `string` | ARN of the GitHub OIDC provider. | Yes |
| `github_repositories` | `list(string)` | List of `org/repo` allowed to assume the role. | Yes |
| `permissions_boundary_arn` | `string` | ARN of the policy acting as a boundary. | No |
| `inline_policy` | `string` | JSON policy document for permissions. | No |
| `managed_policy_arns` | `list(string)` | List of AWS managed policies to attach. | No |

---

## 📝 Logic & Security Notes

### OIDC Trust Policy
The module automatically constructs a trust policy that allows `sts:AssumeRoleWithWebIdentity` ONLY if:
1. The provider matches the `oidc_provider_arn`.
2. The `sub` (subject) claim matches one of the `github_repositories`.
3. The `aud` (audience) claim matches `sts.amazonaws.com`.

### Permissions Boundary
If provided, the `permissions_boundary` is attached to the role. This is critical for **delegated administration**. It ensures that even if a developer has "FullAdmin" permissions within their role, they cannot perform actions forbidden by the boundary (e.g., creating a new user or deleting CloudTrail).
