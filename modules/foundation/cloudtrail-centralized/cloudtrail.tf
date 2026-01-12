variable "trail_name" {
  description = "Name of the CloudTrail"
  type        = string
  default     = "organization-audit-trail"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for log delivery"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for log encryption"
  type        = string
}

variable "is_organization_trail" {
  description = "Whether this is an organization trail"
  type        = bool
  default     = true
}

resource "aws_cloudtrail" "org_trail" {
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket_name
  kms_key_id                    = var.kms_key_id
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.is_organization_trail
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  insight_selector {
    insight_type = "ApiCallRateInsight"
  }

  insight_selector {
    insight_type = "ApiErrorRateInsight"
  }
}

output "trail_arn" {
  value = aws_cloudtrail.org_trail.arn
}

output "trail_id" {
  value = aws_cloudtrail.org_trail.id
}
