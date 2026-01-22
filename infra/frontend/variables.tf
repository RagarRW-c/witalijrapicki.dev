variable "domain_name" {
  description = "Public domain name"
  type = string
}
variable "domain_aliases" {
  description = "All domain aliases for CloudFront"
  type        = list(string)
}

variable "bucket_name" {
  description = "S3 buckeet name for frontend assets"
  type = string
}

variable "project_name" {
  default = "witalijrapicki-portfolio"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN (us-east-1) for CloudFront"
  type        = string
}
