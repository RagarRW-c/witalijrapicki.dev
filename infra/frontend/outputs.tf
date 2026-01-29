output "cloudfront_domain" {
  value = aws_cloudfront_distribution.prod.domain_name
}

output "contact_api_url" {
  value = data.terraform_remote_state.contact.outputs.contact_api_url
}