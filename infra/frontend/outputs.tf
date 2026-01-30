output "cloudfront_domain" {
  value = aws_cloudfront_distribution.prod.domain_name
}

output "contact_api_domain" {
  value = replace(
    aws_api_gateway_stage.prod.invoke_url,
    "https://",
    ""
  )
}
