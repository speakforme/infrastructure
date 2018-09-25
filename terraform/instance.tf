// This is the server where we host everything
// but the main website
resource "aws_instance" "mainserver" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  monitoring    = true
  key_name      = "${aws_key_pair.nemo.key_name}"

  // default VPC so name instead of ID
  security_groups = ["${list(
    aws_security_group.mailserver.name,
    aws_security_group.common.name,
  )}"]

  tags {
    Name      = "mainserver"
    terraform = "true"
  }
}

// Mail Server Elastic IP
// 13.127.221.166
resource "aws_eip" "mailserver" {
  name = "mailserver"
}

resource "aws_eip_association" "mailserver" {
  instance_id   = "${aws_instance.mainserver.id}"
  allocation_id = "${aws_eip.mailserver.id}"
}
