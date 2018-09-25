data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/files/lambda.js"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "store-and-ack" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "store-and-ack"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "lambda.handler"
  runtime          = "nodejs8.10"
  source_code_hash = "${base64sha256(file(data.archive_file.lambda.output_path))}"
}
