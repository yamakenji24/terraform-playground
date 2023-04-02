resource "aws_api_gateway_rest_api" "example_next_api" {
  name = "example_next_api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "example_next_api" {
  rest_api_id   = aws_api_gateway_rest_api.example_next_api.id
  resource_id   = aws_api_gateway_rest_api.example_next_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "aws_api_gateway_resource_paths" {
  rest_api_id   = aws_api_gateway_rest_api.example_next_api.id
  resource_id   = aws_api_gateway_resource.example_resource_paths.id
  http_method   = "ANY"
  authorization = "NONE"
}

# resource "aws_api_gateway_method_settings" "example_next_api_logs" {
#   rest_api_id = aws_api_gateway_rest_api.example_next_api.id
#   stage_name  = aws_api_gateway_stage.example_next_api.stage_name
#   method_path = "*/*"

#   settings {
#     metrics_enabled = true
#     logging_level   = "INFO"
#   }
# }

resource "aws_api_gateway_integration" "example_next_api_root" {
  rest_api_id = aws_api_gateway_rest_api.example_next_api.id
  resource_id = aws_api_gateway_rest_api.example_next_api.root_resource_id
  http_method = aws_api_gateway_method.example_next_api.http_method

  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_next_repo_function.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "example_next_api_paths" {
  rest_api_id = aws_api_gateway_rest_api.example_next_api.id
  resource_id = aws_api_gateway_resource.example_resource_paths.id
  http_method = aws_api_gateway_method.aws_api_gateway_resource_paths.http_method
  type        = "AWS_PROXY"

  uri                     = aws_lambda_function.example_next_repo_function.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_resource" "example_resource_paths" {
  rest_api_id = aws_api_gateway_rest_api.example_next_api.id
  parent_id   = aws_api_gateway_rest_api.example_next_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_deployment" "example_next_api" {
  rest_api_id = aws_api_gateway_rest_api.example_next_api.id

  triggers = {
    redeployment = filebase64("${path.module}/api-gateway.tf")
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.example_next_api_root,
    aws_api_gateway_integration.example_next_api_paths
  ]
}


resource "aws_lambda_permission" "example_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_next_repo_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_next_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_stage" "example_next_api" {
  deployment_id = aws_api_gateway_deployment.example_next_api.id
  rest_api_id   = aws_api_gateway_rest_api.example_next_api.id
  stage_name    = "prod"
}
