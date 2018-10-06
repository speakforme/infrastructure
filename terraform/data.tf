data "aws_caller_identity" "current" {}

locals {
  speakforme_account_id = "${data.aws_caller_identity.current.account_id}"
}

data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
