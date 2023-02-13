module "logging_bucket" {
  providers = { aws = aws.logs }
  source    = "./s3-logging-bucket"
  count     = var.logging_bucket_name == null ? 1 : 0

  logging_bucket_name = var.logging_bucket_name
  logs_prefix         = local.logs_prefix
  source_bucket_arn   = aws_s3_bucket.this.arn
  source_account_id   = data.aws_caller_identity.current.account_id
}
