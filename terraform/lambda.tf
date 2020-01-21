data "archive_file" "email-receipt-lambda" {
  type        = "zip"
  source_dir  = "lambda/email-receipt/"
  output_path = "email-receipt.zip"
}

resource "aws_lambda_function" "store-and-ack" {
  filename      = "${data.archive_file.email-receipt-lambda.output_path}"
  function_name = "store-and-ack"
  role          = "${aws_iam_role.email-receipt-lambda.arn}"
  handler       = "lambda.handler"
  runtime       = "nodejs12.x"

  // Finishes in under 2seconds usually
  timeout          = 5
  source_code_hash = "${base64sha256(file(data.archive_file.email-receipt-lambda.output_path))}"
}

data "archive_file" "unsubscribe-lambda" {
  type        = "zip"
  source_dir  = "lambda/unsubscribe/"
  output_path = "unsubscribe.zip"
}

resource "aws_lambda_function" "unsubscribe" {
  filename         = "${data.archive_file.unsubscribe-lambda.output_path}"
  function_name    = "unsubscribe"
  role             = "${aws_iam_role.unsubscribe-lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = "${base64sha256(file(data.archive_file.unsubscribe-lambda.output_path))}"
}
