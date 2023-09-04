variable "additional_tags" {
  type        = object({})
  description = "Additional tags for the S3 bucket"
  default     = {}
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "bucket_versioning_configuration" {
  type        = string
  description = "Whether to enable bucket versioning"
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.bucket_versioning_configuration)
    error_message = "Allowed values for bucket_versioning_configuration are `Enabled`, `Suspended`, `Disabled`"
  }
}

variable "create_logging_bucket" {
  type        = bool
  description = "Whether to create logging bucket"
  default     = false
}

variable "create_policy" {
  type        = bool
  description = "Whether to create a bucket policy"
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key to use for server side encryption"
  default     = null
}

variable "logging_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for logs. Either an existing logging bucket or the name of the bucket to be created"
}

variable "object_ownership" {
  type        = string
  description = "Object ownership. Valid values: `BucketOwnerPreferred`, `ObjectWriter` or `BucketOwnerEnforced`"
  default     = "BucketOwnerEnforced"
}

variable "override_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document. It will  will iteratively override matching Sids"
  default     = []
}

variable "source_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document. It requires that all documents have unique Sids"
  default     = []
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
