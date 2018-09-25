resource "aws_security_group" "mailserver" {
  name        = "mailserver"
  description = "Mail Server security group"

  tags {
    Name      = "mailserver"
    terraform = true
  }
}

resource "aws_security_group" "common" {
  name        = "common"
  description = "Common security group"

  tags {
    Name      = "common"
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

resource "aws_security_group_rule" "egress-web" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.mailserver.id}"
}

resource "aws_security_group_rule" "egress-web-443" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.common.id}"
}

resource "aws_security_group_rule" "egress-web-80" {
  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.common.id}"
}

resource "aws_security_group_rule" "egress-ssh" {
  type        = "egress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.common.id}"
}

resource "aws_security_group_rule" "egress-icmp" {
  type        = "egress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.common.id}"
}

// Be a good internet citizen
resource "aws_security_group_rule" "ingress-icmp" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.common.id}"
}
