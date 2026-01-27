resource "aws_cloudfront_function" "rewrite_index" {
  name    = "rewrite-index-html"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/cloudfront_function.js")
}