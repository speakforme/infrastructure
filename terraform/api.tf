resource "aws_api_gateway_rest_api" "default" {
  name        = "API"
  description = "Default API Gateway"
}

// Unsubscription
resource "aws_api_gateway_resource" "unsubscribe" {
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  parent_id   = "${aws_api_gateway_rest_api.default.root_resource_id}"
  path_part   = "/unsubscribe"
}

resource "aws_api_gateway_method" "unsubscribe" {
  rest_api_id   = "${aws_api_gateway_rest_api.default.id}"
  resource_id   = "${aws_api_gateway_resource.unsubscribe.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "unsubscribe-lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  resource_id = "${aws_api_gateway_method.unsubscribe.resource_id}"
  http_method = "${aws_api_gateway_method.unsubscribe.http_method}"

  // Lambda functions can only be invoked with a POST
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.unsubscribe.invoke_arn}"
}

resource "aws_api_gateway_deployment" "default" {
  depends_on = [
    "aws_api_gateway_integration.unsubscribe-lambda",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  stage_name  = ""
}
