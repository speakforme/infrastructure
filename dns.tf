resource "aws_route53_zone" "campaign-domain" {
  name = "${var.campaign-domain}"

  tags = {
    Environment = "${var.campaign-env}"
    terraform   = true
  }
}

resource "aws_route53_record" "campaign-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "${var.campaign-a-domain}"
  type    = "A"
  ttl     = "300"
  records = "${var.campaign-a-ip}"
}

resource "aws_route53_record" "postal-mx-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "mx.postal"
  type    = "A"
  ttl     = "300"
  records = "${var.postal-server-ip}"
}

resource "aws_route53_record" "postal-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "postal"
  type    = "A"
  ttl     = "300"
  records = "${var.postal-server-ip}"
}

resource "aws_route53_record" "postal-rp-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "rp.postal"
  type    = "A"
  ttl     = "300"
  records = "${var.postal-server-ip}"
}

resource "aws_route53_record" "postal-sf-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "sf.postal"
  type    = "A"
  ttl     = "300"
  records = "${var.postal-server-ip}"
}

resource "aws_route53_record" "storage-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "storage"
  type    = "A"
  ttl     = "300"
  records = "${var.storage-a-ip}"
}

resource "aws_route53_record" "speakforme-a" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "speakforme.in"
  type    = "A"
  ttl     = "300"
  records = "${var.speakforme-a-ip}"
}

// CNAME Records

resource "aws_route53_record" "beta-cname" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "beta"
  type    = "CNAME"
  ttl     = "1800"
  records = "${var.beta-cname}"
}

resource "aws_route53_record" "netlify-cname" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "netlify"
  type    = "CNAME"
  ttl     = "1800"
  records = "${var.netlify-cname}"
}

resource "aws_route53_record" "psrp-email-cname" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "psrp.email"
  type    = "CNAME"
  ttl     = "1800"
  records = "${var.psrp-email-cname}"
}

resource "aws_route53_record" "psrp-cname" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "psrp"
  type    = "CNAME"
  ttl     = "1800"
  records = "${var.psrp-cname}"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "1800"
  records = "${var.www-cname}"
}

// MX Records
resource "aws_route53_record" "email-mx" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "${var.email-mx-name}"
  type    = "MX"
  ttl     = "60"
  records = "${var.email-mx-record}"
}

resource "aws_route53_record" "routes-mx" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "${var.routes-mx-name}"
  type    = "MX"
  ttl     = "1800"
  records = "${var.routes-mx-record}"
}


resource "aws_route53_record" "speakforme-mx" {
  zone_id = "${aws_route53_zone.campaign-domain.id}"
  name    = "${var.speakforme-mx-name}"
  type    = "MX"
  ttl     = "1800"
  records = "${var.speakforme-mx-record}"
}
