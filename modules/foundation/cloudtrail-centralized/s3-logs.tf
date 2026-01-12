variable "bucket_name" {
  description = "Name of the S3 bucket for centralized logs"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for log encryption"
  type        = string
}

variable "organization_id" {
  description = "The AWS Organization ID"
  type        = string
}

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name

  # Force destroy for examples, but usually false for production logs
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "organization_access" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.organization_access.json
}

data "aws_iam_policy_document" "organization_access" {
  statement {
    sid    = "AllowCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${var.organization_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AllowCloudTrailGetACL"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs.arn]
  }
}

output "s3_bucket_id" {
  value = aws_s3_bucket.logs.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.logs.arn
}
