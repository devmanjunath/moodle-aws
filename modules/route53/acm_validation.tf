resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = var.acm_arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]
}