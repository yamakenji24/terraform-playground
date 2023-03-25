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

data "aws_iam_policy_document" "deploy_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.self.account_id}:oidc-provider/token.actions.githubusercontent.com"] # ID プロバイダの ARN
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
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

data "aws_iam_policy_document" "deploy_to_ecr_document" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.example_next_repo.arn
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "deploy_role" {
  name               = "deploy-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.deploy_assume_role_policy.json
}

resource "aws_iam_policy" "deploy_to_ecr_policy" {
  name        = "deploy_to_ecr_policy"
  path        = "/"
  description = "policy for deploy_to_ecr_policy"

  policy = data.aws_iam_policy_document.deploy_to_ecr_document.json
}


resource "aws_iam_role_policy_attachment" "attach-write-cloudwatch-logs" {
  role       = aws_iam_role.example_lambda_iam.name
  policy_arn = aws_iam_policy.example_write_cloudwatch_log.arn
}

resource "aws_iam_role_policy_attachment" "upload_ecr" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = aws_iam_policy.deploy_to_ecr_policy.arn
}
