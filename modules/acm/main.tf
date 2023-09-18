resource "aws_acm_certificate" "this" {
  domain_name               = "localhost"
  subject_alternative_names = ["*.localhost"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
}
