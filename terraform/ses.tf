resource "aws_ses_receipt_rule_set" "default" {
  rule_set_name = "default"
}

resource "aws_ses_receipt_rule" "store-and-acknowledge" {
  name          = "store-and-ack"
  rule_set_name = "${aws_ses_receipt_rule_set.default.rule_set_name}"
  enabled       = true

  // Emails must be bcc'd to this email address
  recipients = [
    "bcc@email.speakforme.in",

    // This is just so that we can verify this in SES as a sending email
    "info@email.speakforme.in",
  ]

  // We don't need no AV scans
  scan_enabled = false

  // Store Then Process
  s3_action {
    bucket_name = "speakforme-emails"
    position    = 1
  }

  lambda_action {
    function_arn    = "${aws_lambda_function.store-and-ack.arn}"
    invocation_type = "Event"
    position        = 2
  }
}

resource "aws_ses_configuration_set" "default" {
  name = "default"
}
