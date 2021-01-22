resource "aws_acm_certificate" "ssl-cert-dhobighat-tk" {
  domain_name = "dhobighat.tk"
  subject_alternative_names = ["*.dhobighat.tk"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dhobighat-tk-route-validation" {
  name = tolist(aws_acm_certificate.ssl-cert-dhobighat-tk.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.ssl-cert-dhobighat-tk.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.dhobighat-tk-zone.zone_id
  records = [
    tolist(aws_acm_certificate.ssl-cert-dhobighat-tk.domain_validation_options)[0].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "dhobighat-tk-cert-validation" {
  certificate_arn = aws_acm_certificate.ssl-cert-dhobighat-tk.arn
  validation_record_fqdns = aws_route53_record.dhobighat-tk-route-validation.*.fqdn
}