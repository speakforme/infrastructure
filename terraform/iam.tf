// When someone sends us an email
resource "aws_iam_role_policy_attachment" "email-receipt-lambda" {
  role       = "${aws_iam_role.email-receipt-lambda.name}"
  policy_arn = "${aws_iam_policy.email-receipt-lambda.arn}"
}

resource "aws_iam_role" "email-receipt-lambda" {
  name               = "email-receipt-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambda-assume-role.json}"
}

// When a person clicks on Unsubscribe
resource "aws_iam_role" "unsubscribe-lambda" {
  name               = "unsubscribe-lambda-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.apigw-assume-role.json}"
}

resource "aws_iam_role_policy_attachment" "unsubscribe-lambda" {
  role       = "${aws_iam_role.unsubscribe-lambda.name}"
  policy_arn = "${aws_iam_policy.unsubscribe-lambda.arn}"
}
