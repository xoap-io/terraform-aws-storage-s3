variable "name" {
  description = "Name of the bucket to create"
  type        = string
}
variable "versioning" {
  description = "Enables or disables bucket versioning"
  type        = bool
  default     = true
}
variable "kms_arn" {
  description = "KMS Key to use"
  type        = string
}
variable "cors_allowed_methods" {
  description = "Allowed method for CORS access"
  type        = list(string)
  default     = []
}
variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = []
}
variable "cors_allowed_header" {
  description = "Allowed headers for cors"
  type        = list(string)
  default     = []
}
variable "cors_exposed_header" {
  description = "Headers which are exposed through CORS requests"
  type        = list(string)
  default     = []
}
variable "website_enabled" {
  type        = bool
  description = "Enables or disabled static website functionality"
  default     = false
}
variable "index_document" {
  description = "Index page document in S3 bucket"
  type        = string
  default     = "index.html"
}
variable "origin_path" {
  description = "Path in S3 bucket for hosted files, with leading slash"
  type        = string
  default     = "/"
}
variable "routing_rules" {
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
  type        = map(string)
  default = {
    "/" = "index.html"
  }
}
variable "error_document" {
  description = "Error page document in S3 bucket"
  type        = string
  default     = "404.html"
}
variable "is_logging" {
  type        = bool
  default     = false
  description = "Determines if the bucket is intended for logging purposes"
}
variable "acl" {
  type        = string
  default     = "private"
  description = "Default ACL to use when uploading files"
}
variable "logging_bucket" {
  type        = string
  description = "Target bucket for logging"
}
variable "disable_public_access" {
  type        = bool
  default     = true
  description = "Disables or enabled the public access block"
}
variable "bucket_policy" {
  type        = string
  default     = ""
  description = "Bucket policy statement to use"
}
variable "context" {
  type = object({
    organization = string
    environment  = string
    account      = string
    product      = string
    tags         = map(string)
  })
  description = "Default environmental context"
}
locals {
  cors_enabled = length(var.cors_allowed_methods) > 0 && length(var.cors_allowed_origins) > 0 && (length(var.cors_allowed_header) > 0 || length(var.cors_allowed_origins) > 0)
}
