resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "GiveSESPermissionToInvokeFunction"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.store-and-ack.function_name}"
  principal      = "ses.amazonaws.com"
  source_account = "${local.speakforme_account_id}"
}

data "aws_iam_policy_document" "email-receipt-lambda" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
      "ses:SendTemplatedEmail",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
    ]

    resources = ["${aws_dynamodb_table.email-subscriptions.arn}"]
  }
}

resource "aws_iam_policy" "email-receipt-lambda" {
  name   = "email-receipt-lambda"
  path   = "/"
  policy = "${data.aws_iam_policy_document.email-receipt-lambda.json}"
}
