output "arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the created S3 bucket"
}
output "id" {
  value       = aws_s3_bucket.this.id
  description = "ID of the created S3 bucket"
  depends_on  = [aws_s3_bucket_public_access_block.this]
}
output "domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "Regional domain name of the created S3 bucket"
}
output "website_domain" {
  value       = join("", aws_s3_bucket_website_configuration.this.*.website_domain)
  description = "Website domain of the created S3 bucket if hosting is enabled"
}
output "website_endpoint" {
  value       = join("", aws_s3_bucket_website_configuration.this.*.website_endpoint)
  description = "Website endpoint of the created S3 bucket if hosting is enabled"

}
