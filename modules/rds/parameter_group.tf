resource "aws_rds_cluster_parameter_group" "default" {
  name   = lower("${var.name}-parameter-group")
  family = "aurora-mysql5.7"

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
}