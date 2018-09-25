resource "aws_iam_role_policy_attachment" "lambda-ses-send" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.lambda-ses-send.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-logs" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.lambda-logs.arn}"
}

resource "aws_iam_role" "lambda" {
  name               = "kzonovGreeterRoleTF"
  assume_role_policy = "${data.aws_iam_policy_document.lambda-assume-role.json}"
}
