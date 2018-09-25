// This is the server where we host everything
// but the main website
resource "aws_instance" "mainserver" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  monitoring    = true
  key_name      = "${aws_key_pair.nemo.key_name}"

  // default VPC so name instead of ID
  security_groups = ["${aws_security_group.mailserver.name}"]

  tags {
    Name      = "mainserver"
    terraform = "true"
  }
}
