resource "aws_cloudfront_distribution" "prod" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = var.domain_aliases
  comment             = "${var.project_name}-${var.environment}"

  # ===== S3 ORIGIN =====
  origin {
    domain_name              = data.aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "s3-frontend"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # ===== CONTACT API ORIGIN =====
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
      origin_ssl_protocols   = ["TLSv3"]
    }
  }


  # ===== DEFAULT (S3) =====
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

    # REWRITE TYLKO DLA S3
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_index.arn
    }
  }

  # ===== /contact → API =====
  ordered_cache_behavior {
    path_pattern     = "/contact*"
    target_origin_id = "contact-api"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "HEAD",
      "DELETE",
      "POST",
      "GET",
      "OPTIONS",
      "PUT",
      "PATCH"
    ]

    cached_methods = [
      "HEAD",
      "GET"
    ]

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Content-Type"]

      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.3_2025"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "site-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
