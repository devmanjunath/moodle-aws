resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = "Route53 for ${var.name}"
  dynamic "vpc" {
    for_each = var.vpc_id != "" ? [0] : []
    content {
      vpc_id = var.vpc_id
    }
  }
}
