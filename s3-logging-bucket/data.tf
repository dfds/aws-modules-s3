data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "logging" {
  statement {
    sid = "S3ServerAccessLogsPolicy"
    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/${var.logs_prefix}*"
    ]
    condition {
      test     = "ArnLike"
      values   = [var.source_bucket_arn]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [var.source_account_id != null ? var.source_account_id : data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}
