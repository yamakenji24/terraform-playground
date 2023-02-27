resource "aws_s3_bucket" "example_s3" {
  bucket = "frontend-s3-bucket-testest"
}

resource "aws_s3_bucket_policy" "bucket" {
    bucket = aws_s3_bucket.example_s3.id
    policy = data.aws_iam_policy_document.example_bucket_policy_document.json
}

data "aws_iam_policy_document" "example_bucket_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.example_s3.arn}/*"]
  }
}