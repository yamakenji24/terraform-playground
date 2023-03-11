data "aws_acm_certificate" "test_yamakenji_dev" {
  // ACM attaching to cloudfront needs to exist in us-east-1
  provider = aws.us-east-1

  domain      = "test.yamakenji.dev"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}
