module "logging_bucket" {
  source = "./s3-logging-bucket"
  count  = var.create_logging_bucket ? 1 : 0

  bucket_name = var.logging_bucket_name
  source_buckets = [
    {
      logs_prefix       = local.logs_prefix
      source_bucket_arn = aws_s3_bucket.this.arn
    }
  ]
}
