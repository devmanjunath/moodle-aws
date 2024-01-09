resource "aws_route53_record" "name_servers" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.this.zone_id

  records = [
    aws_route53_zone.this.name_servers[0],
    aws_route53_zone.this.name_servers[1],
    aws_route53_zone.this.name_servers[2],
    aws_route53_zone.this.name_servers[3],
  ]
}