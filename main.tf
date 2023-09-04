resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(
    {
      Name = var.bucket_name
    },
    var.additional_tags
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.create_policy ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn != null ? var.kms_key_arn : null
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket
  versioning_configuration {
    status = var.bucket_versioning_configuration
  }
}

resource "aws_s3_bucket_logging" "this" {
  depends_on = [module.logging_bucket]

  bucket        = aws_s3_bucket.this.bucket
  target_bucket = var.logging_bucket_name
  target_prefix = local.logs_prefix
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) != 0 ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "filter" {
        for_each = lookup(rule.value, "filter", null) != null ? [rule.value.filter] : []
        content {
          dynamic "and" {
            for_each = lookup(rule.value.filter, "and", null) != null ? [rule.value.filter.and] : []
            content {
              object_size_greater_than = lookup(and.value, "object_size_greater_than", null)
              object_size_less_than    = lookup(and.value, "object_size_less_than", null)
              prefix                   = lookup(and.value, "prefix", null)
              tags                     = lookup(and.value, "tags", null)
            }
          }

          object_size_greater_than = lookup(rule.value.filter, "object_size_greater_than", null)
          object_size_less_than    = lookup(rule.value.filter, "object_size_less_than", null)
          prefix                   = lookup(rule.value.filter, "prefix", "")

          dynamic "tag" {
            for_each = lookup(rule.value.filter, "tag", null) != null ? [rule.value.filter.tag] : []
            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", null) != null ? [rule.value.expiration] : []
        content {
          date = lookup(expiration.value, "date", null)
          days = lookup(expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lookup(rule.value, "noncurrent_version_expiration", null) != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          newer_noncurrent_versions = lookup(noncurrent_version_expiration.value, "newer_noncurrent_versions", null)
          noncurrent_days           = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transition", null) != null ? [rule.value.noncurrent_version_transition] : []
        content {
          newer_noncurrent_versions = lookup(noncurrent_version_transition.value, "newer_noncurrent_versions", null)
          noncurrent_days           = lookup(noncurrent_version_transition.value, "noncurrent_days", null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", null) != null ? [rule.value.transition] : []
        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = lookup(rule.value, "abort_incomplete_multipart_upload", null) != null ? [rule.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}
