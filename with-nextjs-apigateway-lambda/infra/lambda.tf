resource "aws_ecr_repository" "example_next_repo" {
  name                 = "example_next_repo"
}

resource "aws_lambda_function" "example_next_repo_function" {
  function_name = "exampleNextRepo"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.example_next_repo.repository_url}:latest"
  role          = aws_iam_role.example_lambda_iam.arn
  timeout       = 30

  lifecycle {
    ignore_changes = [
      image_uri
    ]
  }

  depends_on = [
    aws_ecr_repository.example_next_repo
  ]
}