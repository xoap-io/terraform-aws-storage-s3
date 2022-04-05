module "this_label" {
  source     = "git::github.com/xoap-io/terraform-aws-misc-label?ref=v0.1.0"
  context    = var.context
  attributes = [var.name]
}

resource "aws_s3_bucket" "this" {
  bucket        = module.this_label.id
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.disable_public_access
  block_public_policy     = var.disable_public_access
  restrict_public_buckets = var.disable_public_access
  ignore_public_acls      = var.disable_public_access
}
resource "aws_s3_bucket_policy" "this" {
  count  = var.bucket_policy != "" ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.is_logging == true ? "log-delivery-write" : var.acl != "" ? var.acl : "private"
}
resource "aws_s3_bucket_cors_configuration" "this" {
  count  = local.cors_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  cors_rule {
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    allowed_headers = var.cors_allowed_header
    expose_headers  = var.cors_exposed_header
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.kms_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_arn
    }
  }
}
resource "aws_s3_bucket_versioning" "this" {
  count  = var.versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.website_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }

  dynamic "routing_rule" {

    for_each = var.routing_rules
    content {
      condition {
        key_prefix_equals = routing_rule.key
      }
      redirect {
        replace_key_prefix_with = routing_rule.value
      }
    }
  }
}
resource "aws_s3_bucket_logging" "this" {
  count         = var.logging_bucket != "" ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging_bucket
  target_prefix = module.this_label.id
}
