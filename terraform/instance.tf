resource "aws_instance" "mailserver" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  monitoring    = true

  // default VPC so name instead of ID
  security_groups = ["${aws_security_group.mailserver.name}"]

  tags {
    Name      = "mailserver"
    terraform = "true"
  }
}
