resource "aws_ses_template" "acknowledge" {
  name = "Acknowledgement"
  text = "${file("${path.module}/files/ack.txt")}"
}

resource "aws_ses_receipt_rule_set" "default" {
  rule_set_name = "default"
}

resource "aws_ses_receipt_rule" "store-and-acknowledge" {
  name          = "store-and-ack"
  rule_set_name = "${aws_ses_receipt_rule_set.default.rule_set_name}"
  enabled       = true

  // Emails must be bcc'd to this email address
  recipients = ["bcc@email.speakforme.in"]

  // We don't need no AV scans
  scan_enabled = false

  lambda_action {
    function_arn    = "${aws_lambda_function.store-and-ack.arn}"
    invocation_type = "Event"
    position        = 1
  }

  s3_action {
    bucket_name = "speakforme-emails"
    position    = 1
  }
}
