variable "key_alias" {
  description = "Alias for the KMS key"
  type        = string
  default     = "alias/centralized-logs"
}

variable "trusted_account_ids" {
  description = "List of AWS account IDs allowed to use this key"
  type        = list(string)
  default     = []
}

resource "aws_kms_key" "logs" {
  description             = "KMS key for centralized log encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key_policy.json
}

resource "aws_kms_alias" "logs" {
  name          = var.key_alias
  target_key_id = aws_kms_key.logs.key_id
}

data "aws_iam_policy_document" "key_policy" {
  # Key administration (current account root)
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Allow CloudTrail to use the key
  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  # Allow trusted accounts (spokes) to use the key
  dynamic "statement" {
    for_each = length(var.trusted_account_ids) > 0 ? [1] : []
    content {
      sid    = "Allow Spoke Accounts"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [for id in var.trusted_account_ids : "arn:aws:iam::${id}:root"]
      }
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
    }
  }
}

data "aws_caller_identity" "current" {}

output "key_arn" {
  value = aws_kms_key.logs.arn
}

output "key_id" {
  value = aws_kms_key.logs.key_id
}
