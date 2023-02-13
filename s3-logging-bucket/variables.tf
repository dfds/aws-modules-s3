variable "logging_bucket_name" {
  type        = string
  description = "Name of the logging bucket"
}

variable "logs_prefix" {
  type        = string
  description = "Prefix for logs"
}

variable "source_bucket_arn" {
  type        = string
  description = "ARN of the source bucket"
}

variable "source_account_id" {
  type        = string
  description = "ID of the account where the source bucket is"
}
