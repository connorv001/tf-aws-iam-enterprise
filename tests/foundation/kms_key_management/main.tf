module "kms_key" {
  source = "../../../modules/foundation/kms-key-management"

  key_alias = "alias/test-key"
  trusted_account_ids = ["123456789012"]
}

output "key_arn" {
  value = module.kms_key.key_arn
}
