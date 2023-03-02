variable "bucket_name" {
  type        = string
  description = "Name of the logging bucket"
}

variable "source_buckets" {
  type = list(object({
    source_bucket_arn = string
    logs_prefix       = string
  }))
  description = "List of source buckets"
}
