resource "aws_security_group" "mailserver" {
  name        = "mailserver"
  description = "Mail Server security group"

  tags {
    terraform = true
  }
}

resource "aws_security_group_rule" "open-smtp" {
  type        = "ingress"
  from_port   = 25
  to_port     = 25
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.mailserver.id}"
}

resource "aws_security_group_rule" "open-ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.mailserver.id}"
}
