# KMS Key Management

This module manages Customer Managed Keys (CMKs) for centralized encryption, supporting multi-account access patterns.

## Features

- **Centralized Management**: Keys are defined in the central account.
- **Cross-Account Access**: Allows spoke accounts to use keys for encryption/decryption via `trusted_account_ids`.
- **CloudTrail Integration**: Explicitly allows CloudTrail to encrypt logs.
- **Key Rotation**: Automatic yearly rotation enabled.

## Usage

```hcl
module "logs_key" {
  source = "./modules/foundation/kms-key-management"

  key_alias           = "alias/central-logs"
  trusted_account_ids = ["111122223333", "444455556666"] # Spoke Account IDs
}
```

## Policy Structure

The key policy allows:
1. **Root Access**: `kms:*` for the current account root (enables IAM delegation).
2. **CloudTrail**: `kms:GenerateDataKey*` and `kms:Decrypt` for log delivery.
3. **Spokes**: `kms:Encrypt`, `kms:Decrypt`, `kms:ReEncrypt*`, `kms:GenerateDataKey*` for trusted accounts.
