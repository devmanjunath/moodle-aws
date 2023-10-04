resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  lifecycle {
    prevent_destroy = true
  }
}
