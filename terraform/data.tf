locals {
  // https://cloud-images.ubuntu.com/locator/ec2/
  // https://aws.amazon.com/marketplace/pp/B07CQ33QKV?qid=1537901461645&sr=0-2&ref_=srh_res_product_title
  canonical_account_id = "099720109477"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${local.canonical_account_id}"]
}
