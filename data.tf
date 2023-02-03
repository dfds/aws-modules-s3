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
