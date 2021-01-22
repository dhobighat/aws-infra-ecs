resource "aws_route53_zone" "dhobighat-tk-zone" {
  name = "dhobighat.tk"
}

resource "aws_route53_record" "dhobighat-tk-zone" {
  zone_id = aws_route53_zone.dhobighat-tk-zone.zone_id
  name    = "dhobighat.tk"
  type    = "A"

  alias {
    name                   = aws_alb.dev-alb.dns_name
    zone_id                = aws_alb.dev-alb.zone_id
    evaluate_target_health = true
  }
}