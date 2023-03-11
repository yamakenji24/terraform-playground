resource "aws_s3_bucket" "example_s3" {
  bucket = "frontend-s3-bucket-testest"
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.example_s3.id
  policy = data.aws_iam_policy_document.example_bucket_policy_document.json
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.example_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "example_bucket_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.example_s3.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        aws_cloudfront_distribution.example_cloudfront.arn,
      ]
    }
  }
}
