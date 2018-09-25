// TODO: Convert these 2 to proper terraform

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "GiveSESPermissionToInvokeFunction"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.store-and-ack.function_name}"
  principal      = "ses.amazonaws.com"
  source_account = "${local.speakforme_account_id}"
}

resource "aws_iam_policy" "lambda-logs" {
  name        = "lambda-logs-policy"
  path        = "/"
  description = ""

  policy = <<EOF
{
   "Effect": "Allow",
   "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
   ],
   "Resource": "arn:aws:logs:*:*:*"
}
EOF
}

resource "aws_iam_policy" "lambda-ses-send" {
  name        = "lambda-logs-policy"
  path        = "/"
  description = ""

  policy = <<EOF
{
   "Effect": "Allow",
   "Action": "ses:SendRawEmail",
   "Resource": "*"
}
EOF
}
