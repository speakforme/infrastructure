// IAM policy for the email receipt lambda job
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

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]

    resources = ["${aws_dynamodb_table.email-counters.arn}"]
  }
}

resource "aws_iam_policy" "email-receipt-lambda" {
  name   = "email-receipt-lambda"
  path   = "/"
  policy = "${data.aws_iam_policy_document.email-receipt-lambda.json}"
}

// IAM policy for the unsubscribe lambda
data "aws_iam_policy_document" "unsubscribe-lambda" {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]

    resources = ["${aws_dynamodb_table.email-subscriptions.arn}"]
  }

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
}

resource "aws_iam_policy" "unsubscribe-lambda" {
  name   = "unsubscribe-lambda"
  path   = "/"
  policy = "${data.aws_iam_policy_document.unsubscribe-lambda.json}"
}
