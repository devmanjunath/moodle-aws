resource "aws_acm_certificate_validation" "domain_validation" {
  depends_on              = [aws_route53_record.acm_record]
  certificate_arn         = var.acm_arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]
  timeouts {
    create = "120m"
  }
}
