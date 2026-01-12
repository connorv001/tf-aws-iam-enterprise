# IAM Password Policy

This module enforces a strict password policy for all IAM users in the account, compliant with CIS AWS Foundations Benchmark v1.4.0.

## Policy Settings

| Setting | Value | Justification |
|---------|-------|---------------|
| **Minimum Length** | 14 characters | CIS 1.9 compliance |
| **Complexity** | Upper, Lower, Number, Symbol | CIS 1.5-1.8 compliance |
| **Max Age** | 90 days | CIS 1.11 compliance |
| **Reuse Prevention** | Last 24 passwords | CIS 1.10 compliance |
| **User Change** | Allowed | Enables self-service rotation |

## Usage

This module is deployed as part of the Foundation stack. No parameters are required for standard deployment.

```hcl
module "password_policy" {
  source = "./modules/foundation/iam-password-policy"
}
```
