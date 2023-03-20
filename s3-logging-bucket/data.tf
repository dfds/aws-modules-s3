data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}

data "aws_iam_policy_document" "logging" {

  dynamic "statement" {
    for_each = var.source_buckets
    iterator = i

    content {
      principals {
        identifiers = ["logging.s3.amazonaws.com"]
        type        = "Service"
      }
      actions = [
        "s3:PutObject"
      ]
      resources = [

        "${aws_s3_bucket.this.arn}/${i.value.logs_prefix}*"
      ]
      condition {
        test     = "ArnLike"
        values   = [i.value.source_bucket_arn]
        variable = "aws:SourceArn"
      }
      condition {
        test     = "StringEquals"
        values   = [data.aws_caller_identity.current.account_id]
        variable = "aws:SourceAccount"
      }
    }
  }
}
