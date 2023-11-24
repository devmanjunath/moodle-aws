resource "random_password" "DatabaseMasterPassword" {
  length           = 16
  special          = true
  override_special = "!#$%^*()-=+_?{}|"
}

resource "aws_rds_cluster" "aurora_serverless" {
  cluster_identifier        = lower("${var.name}-db")
  engine                    = "aurora-mysql"
  master_username           = "admin"
  master_password           = random_password.DatabaseMasterPassword.result
  vpc_security_group_ids    = var.security_group
  db_subnet_group_name      = aws_db_subnet_group.default.id
  final_snapshot_identifier = "${var.name}-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier       = try(data.aws_db_snapshot.latest_snapshot.0.id, null)
  skip_final_snapshot       = false
  database_name             = "moodle"

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      final_snapshot_identifier
    ]
  }
}
