// Allow SES to trigger Lambda
resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "GiveSESPermissionToInvokeFunction"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.store-and-ack.function_name}"
  principal      = "ses.amazonaws.com"
  source_account = "${local.account_id}"
}

// Allow API Gateway to trigger unsubscribe API
resource "aws_lambda_permission" "allow_apigw_unsubscribe" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.unsubscribe.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  # (All software sucks)
  source_arn = "${aws_api_gateway_deployment.default.execution_arn}/*/*"
}
