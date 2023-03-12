
resource "aws_cloudfront_distribution" "example_cloudfront" {
  provider = aws.us-east-1

  aliases = [
    data.aws_acm_certificate.test_yamakenji_dev.domain,
  ]

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.test_yamakenji_dev.arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // s3
  origin {
    origin_id                = aws_s3_bucket.example_s3.id
    domain_name              = aws_s3_bucket.example_s3.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.access_s3.id
  }

  // api-gateway
  origin {
    origin_id   = aws_api_gateway_rest_api.example_next_api.id
    domain_name = "${aws_api_gateway_rest_api.example_next_api.id}.execute-api.ap-northeast-1.amazonaws.com"
    origin_path = "/${aws_api_gateway_stage.example_next_api.stage_name}"

    custom_origin_config {
      http_port  = 80
      https_port = 443

      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }

  default_cache_behavior {
    target_origin_id       = aws_api_gateway_rest_api.example_next_api.id
    viewer_protocol_policy = "allow-all"

    compress = false

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      headers      = []
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    target_origin_id       = aws_api_gateway_rest_api.example_next_api.id
    viewer_protocol_policy = "allow-all"
    path_pattern           = "/_next/data/*"
    compress               = false
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      headers      = []
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    target_origin_id       = aws_s3_bucket.example_s3.id
    viewer_protocol_policy = "allow-all"
    path_pattern           = "/_next/*"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      headers      = []
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
}

resource "aws_cloudfront_origin_access_control" "access_s3" {
  name                              = "access-s3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
