resource "aws_route53_zone" "zone" {
  name = "yamakenji.dev"
}

resource "aws_route53_record" "_ddc46703102682e5b915a65882180db7_test_yamakenji_dev" {
  name    = "_ddc46703102682e5b915a65882180db7.${aws_route53_zone.zone.name}"
  records = ["_05e93036458a1bfb807b6bcf75ea436e.cltjbwlkcy.acm-validations.aws."]
  ttl     = 300
  type    = "CNAME"
  zone_id = aws_route53_zone.zone.id
}

resource "aws_route53_record" "test_yamakenji_dev" {
  name    = "test.${aws_route53_zone.zone.name}"
  zone_id = aws_route53_zone.zone.id
  type    = "A"

  alias {
    name                   = "d170i0kgxa8mx7.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
