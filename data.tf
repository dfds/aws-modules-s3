data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket" {

  override_policy_documents = var.override_policy_documents
  source_policy_documents   = var.source_policy_documents

  statement {
    sid     = "AllowSSLRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
      aws_s3_bucket.this.arn
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = [false]
      variable = "aws:SecureTransport"
    }

    condition {
      test     = "NumericLessThan"
      values   = [1.2]
      variable = "s3:TlsVersion"
    }
  }
}

data "aws_iam_policy_document" "kms" {
  count = var.create_kms ? 1 : 0

  source_policy_documents   = var.kms_source_policy_documents
  override_policy_documents = var.kms_override_policy_documents

  dynamic "statement" {
    for_each = var.enable_default_policy ? ["OK"] : []

    content {
      sid       = "DefaultPolicy"
      actions   = ["kms:*"]
      resources = ["*"]

      principals {
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.key_administrators) > 0 ? ["OK"] : []

    content {
      sid = "KeyAdmin"
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
      resources = ["*"]

      principals {
        identifiers = var.key_administrators
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.key_users) > 0 ? ["OK"] : []

    content {
      sid = "KeyUser"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ]
      resources = ["*"]

      principals {
        identifiers = var.key_users
        type        = "AWS"
      }
    }
  }
}
