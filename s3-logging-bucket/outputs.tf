output "logging_bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "Name of the logging S3 bucket"
}
