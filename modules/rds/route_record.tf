resource "aws_route53_record" "lb_record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.this.address]
}
