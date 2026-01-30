resource "aws_cloudfront_distribution" "prod" {
  enabled             = true
  comment             = "${var.project_name}-${var.environment}"
  aliases             = var.domain_aliases
  default_root_object = "index.html"

  # =========================
  # ORIGIN: S3 FRONTEND
  # =========================
  origin {
    domain_name              = data.aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "s3-frontend"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # =========================
  # ORIGIN: CONTACT API
  # =========================
  origin {
    domain_name = split(
      "/",
      replace(
        data.terraform_remote_state.contact.outputs.contact_api_url,
        "https://",
        ""
      )
    )[0]

    origin_id = "contact-api"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # =========================
  # DEFAULT CACHE (S3)
  # =========================
  default_cache_behavior {
    target_origin_id       = "s3-frontend"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Rewrite /contact → /contact/index.html
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_index.arn
    }
  }

  # =========================
  # API: /api/contact
  # =========================
  ordered_cache_behavior {
    path_pattern     = "/api/contact*"
    target_origin_id = "contact-api"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "POST"
    ]

    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Content-Type"]

      cookies {
        forward = "all"
      }
    }
  }

  # =========================
  # SSL
  # =========================
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.3_2021"
  }

  # =========================
  # GEO
  # =========================
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # =========================
  # ERROR HANDLING (SSG)
  # =========================
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }
}

# =========================
# ORIGIN ACCESS CONTROL
# =========================
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-${var.environment}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
