resource "aws_iam_role" "example_lambda_iam" {
  name = "example_lambda_iam"

  assume_role_policy = data.aws_iam_policy_document.example_lambda_document.json
}

resource "aws_iam_policy" "example_write_cloudwatch_log" {
  name = "write-cloudwatch-logs-policy"
  path = "/"

  policy = data.aws_iam_policy_document.example_write_cloudwatch_log_document.json
}

resource "aws_iam_role_policy_attachment" "example_attach_write_cloudwatch_log" {
  role       = aws_iam_role.example_lambda_iam.name
  policy_arn = aws_iam_policy.example_write_cloudwatch_log.arn
}

data "aws_iam_policy_document" "example_lambda_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "example_write_cloudwatch_log_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
}
