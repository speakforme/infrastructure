resource "aws_ses_template" "acknowledge" {
  name    = "Acknowledgement"
  subject = "Thanks for speaking up!"
  html    = "${file("${path.module}/files/ack.html")}"
  text    = "${file("${path.module}/files/ack.txt")}"
}

resource "aws_ses_receipt_rule_set" "default" {
  rule_set_name = "default"
}

resource "aws_ses_receipt_rule" "store-and-acknowledge" {
  name          = "store-and-ack"
  rule_set_name = "${aws_ses_receipt_rule_set.default.rule_set_name}"
  enabled       = true

  // We don't need no AV scans
  scan_enabled = false

  lambda_action {
    function_arn    = "${aws_lambda_function.store-and-ack.arn}"
    invocation_type = "RequestResponse"
    position        = 2
  }

  # s3_action {
  #   bucket_name       = "speakforme-infrastructure"
  #   object_key_prefix = "emails/"
  #   position          = 1
  # }
}
