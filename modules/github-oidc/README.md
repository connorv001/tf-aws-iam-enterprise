# GitHub OIDC Provider Module

**The Foundation of Trust.**

---

## 📖 Overview

This module establishes the OpenID Connect (OIDC) trust relationship between your AWS account and GitHub Actions. This allows GitHub to mint JSON Web Tokens (JWTs) that AWS STS can validate, enabling **keyless authentication**.

### Why This Matters
- **Eliminates Long-Lived Keys:** No more `AWS_ACCESS_KEY_ID` secrets stored in GitHub.
- **Improved Security:** Tokens are short-lived (usually 1 hour).
- **Auditability:** CloudTrail logs show exactly which repo and workflow assumed a role.

---

## 🛠 Usage

This module should be instantiated **once per AWS account** (usually in the Foundation or Security layer).

```hcl
module "github_oidc" {
  source = "./modules/github-oidc"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

Once deployed, you can use the output `provider_arn` in your IAM Trust Policies (or use the `app-role-generator` which handles this for you).

---

## 📝 Technical Details

### Thumbprint Management
This module uses the `tls_certificate` data source to **dynamically fetch** the thumbprint of GitHub's OIDC server (`token.actions.githubusercontent.com`). This ensures that if GitHub rotates their certificates, a simple `terraform apply` will update the trust store without hardcoding values.

### Audience (aud)
The provider is configured with `client_id_list = ["sts.amazonaws.com"]`. This matches the standard audience claim in tokens issued by GitHub Actions for AWS.
