resource "aws_route53_record" "lb_record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_elasticache_cluster.this.cache_nodes[0]["address"]]
}
