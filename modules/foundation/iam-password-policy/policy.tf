variable "minimum_password_length" {
  description = "Minimum number of characters allowed in an IAM user password"
  type        = number
  default     = 14
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for IAM user passwords"
  type        = bool
  default     = true
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for IAM user passwords"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Whether to require numbers for IAM user passwords"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Whether to require symbols for IAM user passwords"
  type        = bool
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Whether to allow IAM users to change their own password"
  type        = bool
  default     = true
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that IAM users are prevented from reusing"
  type        = number
  default     = 24
}

variable "max_password_age" {
  description = "The number of days that an IAM user password is valid"
  type        = number
  default     = 90
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = var.minimum_password_length
  require_lowercase_characters   = var.require_lowercase_characters
  require_uppercase_characters   = var.require_uppercase_characters
  require_numbers                = var.require_numbers
  require_symbols                = var.require_symbols
  allow_users_to_change_password = var.allow_users_to_change_password
  password_reuse_prevention      = var.password_reuse_prevention
  max_password_age               = var.max_password_age
}
