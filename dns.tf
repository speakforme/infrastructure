resource "aws_route53_zone" "speakforme-in" {
  name = "speakforme.in"

  tags {
    Environment = "production"
    terraform   = true
  }
}

resource "aws_route53_record" "speakforme-a" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "speakforme.in"
  type    = "A"
  ttl     = "300"

  // Netlify
  records = ["104.198.14.52"]
}

resource "aws_route53_record" "netlify-cname" {
  zone_id = "${aws_route53_zone.speakforme-in.id}"
  name    = "netlify"
  type    = "CNAME"
  ttl     = "1800"
  records = ["speakforme.netlify.com."]
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
    "10 inbound-smtp.eu-west-1.amazonaws.com.",
  ]
}
