variable "analyzer_name" {
  description = "Name of the IAM Access Analyzer"
  type        = string
  default     = "organization-access-analyzer"
}

variable "type" {
  description = "The type of analyzer, which corresponds to the zone of trust chosen for the analyzer"
  type        = string
  default     = "ORGANIZATION"
}

resource "aws_accessanalyzer_analyzer" "org" {
  analyzer_name = var.analyzer_name
  type          = var.type
}

output "analyzer_arn" {
  value = aws_accessanalyzer_analyzer.org.arn
}
