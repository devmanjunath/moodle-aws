resource "aws_elasticache_cluster" "this" {
  cluster_id           = lower("${var.name}")
  engine               = "redis"
  node_type            = var.instance_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  security_group_ids   = var.security_group
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}
