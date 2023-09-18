resource "aws_elasticache_cluster" "this" {
  cluster_id           = lower("${var.name}-cluster")
  engine               = "memcached"
  node_type            = "cache.t3.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  security_group_ids   = var.security_group
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}
