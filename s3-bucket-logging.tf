module "logging_bucket" {
  source = "./s3-logging-bucket"
  count  = var.logging_bucket_name != "" ? 1 : 0

  logging_bucket_name = "${var.bucket_name}-logs"
  logs_prefix         = local.logs_prefix
  source_bucket_arn   = aws_s3_bucket.this.arn
  source_account_id   = data.aws_caller_identity.current.account_id
}
