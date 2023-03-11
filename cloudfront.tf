
resource "aws_cloudfront_distribution" "example_cloudfront" {
  provider = aws.us-east-1

  aliases = [
    data.aws_acm_certificate.test_yamakenji_dev.domain,
  ]

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

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

  origin {
    origin_id                = aws_s3_bucket.example_s3.id
    domain_name              = aws_s3_bucket.example_s3.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.access_s3.id
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.example_s3.id
    viewer_protocol_policy = "allow-all"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
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
