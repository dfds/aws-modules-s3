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

variable "logging" {
  type = object({
    target_bucket = optional(string)
    target_prefix = optional(string)
  })
  description = "The logging configuration for the S3 bucket"
  default     = {}
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


## KMS

variable "create_kms" {
  type        = bool
  description = "Whether to create a KMS key for S3 bucket"
  default     = true
}

variable "kms_key_alias" {
  type        = string
  description = "Alias for the KMS key"
  default     = ""
}

variable "enable_default_policy" {
  type        = bool
  description = "Whether to enable default policy for KMS key"
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "Whether to enable key rotation"
  default     = true
}

variable "key_administrators" {
  type        = list(string)
  description = "List of KMS key administrators"
  default     = []
}

variable "key_users" {
  type        = list(string)
  description = "List of KMS key users"
  default     = []
}

variable "kms_override_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document"
  default     = []
}

variable "kms_source_policy_documents" {
  type        = list(string)
  description = "List of IAM policy documents that are merged together into the exported document"
  default     = []
}
