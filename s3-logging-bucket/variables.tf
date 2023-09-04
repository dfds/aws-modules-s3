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

variable "lifecycle_rules" {
  type = list(object({
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = optional(number)
    }))
    expiration = optional(object({
      date = optional(string)
      days = optional(number)
    }))
    filter = optional(object({
      and = optional(object({
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        prefix                   = optional(string)
        tags                     = optional(map(string))
      }))
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      prefix                   = optional(string)
      tag = optional(object({
        key   = optional(string)
        value = optional(string)
      }))
    }))
    id = string
    noncurrent_version_expiration = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
    }))
    noncurrent_version_transition = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
      storage_class             = string
    }))
    status = string
    transition = optional(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = optional(string)
    }))
  }))
  description = "List of objects lifecycle rules"
  default     = []
}
