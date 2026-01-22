variable "domain_name" {
  description = "Public domain name"
  type = string
}

variable "bucket_name" {
  description = "S3 buckeet name for frontend assets"
  type = string
}

variable "project_name" {
  default = "witalijrapicki-portfolio"
}