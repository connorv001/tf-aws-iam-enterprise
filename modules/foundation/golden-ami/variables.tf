# modules/foundation/golden-ami/variables.tf

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
