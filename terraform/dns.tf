resource "aws_route53_zone" "speakforme-in" {
  name = "speakforme.in"

  tags {
    Environment = "production"
    terraform   = true
  }
}

resource "aws_route53_record" "campaign-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "campaign.speakforme.in"
  type    = "A"
  ttl     = "300"
  records = ["34.199.252.2"]
}

locals {
  postal-server-ip = "18.211.250.184"
}

resource "aws_route53_record" "postal-mx-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "mx.postal"
  type    = "A"
  ttl     = "300"
  records = ["${local.postal-server-ip}"]
}

resource "aws_route53_record" "postal-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "postal"
  type    = "A"
  ttl     = "300"
  records = ["${local.postal-server-ip}"]
}

resource "aws_route53_record" "postal-rp-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "rp.postal"
  type    = "A"
  ttl     = "300"
  records = ["${local.postal-server-ip}"]
}

resource "aws_route53_record" "postal-sf-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "sf.postal"
  type    = "A"
  ttl     = "300"
  records = ["${local.postal-server-ip}"]
}

resource "aws_route53_record" "storage-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "storage"
  type    = "A"
  ttl     = "300"
  records = ["35.153.240.239"]
}

resource "aws_route53_record" "speakforme-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "speakforme.in"
  type    = "A"
  ttl     = "300"
  records = ["104.198.14.52"]
}

// CNAME Records

resource "aws_route53_record" "beta-cname" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "beta"
  type    = "CNAME"
  ttl     = "1800"
  records = ["speakforme.github.io."]
}

resource "aws_route53_record" "netlify-cname" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "netlify"
  type    = "CNAME"
  ttl     = "1800"
  records = ["speakforme.netlify.com."]
}

resource "aws_route53_record" "psrp-email-cname" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "psrp.email"
  type    = "CNAME"
  ttl     = "1800"
  records = ["rp.postal.speakforme.in."]
}

resource "aws_route53_record" "psrp-cname" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "psrp"
  type    = "CNAME"
  ttl     = "1800"
  records = ["rp.postal.speakforme.in."]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "1800"
  records = ["speakforme.netlify.com."]
}

// MX Records

resource "aws_route53_record" "email-mx" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "email"
  type    = "MX"
  ttl     = "60"

  records = [
    "10 ${aws_eip.mailserver.public_ip}",
    "10 mx.postal.speakforme.in.",
  ]
}

resource "aws_route53_record" "routes-mx" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "routes"
  type    = "MX"
  ttl     = "1800"

  records = [
    "10 mx.postal.speakforme.in.",
  ]
}

resource "aws_route53_record" "speakforme-mx" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "speakforme.in"
  type    = "MX"
  ttl     = "1800"

  records = [
    "10 mx.postal.speakforme.in.",
  ]
}

resource "aws_route53_record" "info-mx" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "info"
  type    = "MX"
  ttl     = "1800"

  records = [
    "10 feedback-smtp.us-east-1.amazonses.com.",
  ]
}
