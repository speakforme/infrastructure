data "archive_file" "email-receipt-lambda" {
  type        = "zip"
  source_dir  = "files/lambda/"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "store-and-ack" {
  filename         = "${data.archive_file.email-receipt-lambda.output_path}"
  function_name    = "store-and-ack"
  role             = "${aws_iam_role.email-receipt-lambda.arn}"
  handler          = "lambda.handler"
  runtime          = "nodejs8.10"
  source_code_hash = "${base64sha256(file(data.archive_file.email-receipt-lambda.output_path))}"
}
