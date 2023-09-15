resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier           = lower("${var.name}-instance")
  cluster_identifier   = aws_rds_cluster.aurora_serverless.id
  engine               = aws_rds_cluster.aurora_serverless.engine
  engine_version       = aws_rds_cluster.aurora_serverless.engine_version
  instance_class       = "db.serverless"
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.default.id
}
