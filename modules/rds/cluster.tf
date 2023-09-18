resource "random_password" "DatabaseMasterPassword" {
  length           = 16
  special          = true
  override_special = "!#$%^*()-=+_?{}|"
}

resource "aws_rds_cluster" "aurora_serverless" {
  cluster_identifier     = lower("${var.name}-db")
  engine                 = "aurora-mysql"
  master_username        = "admin"
  master_password        = random_password.DatabaseMasterPassword.result
  vpc_security_group_ids = var.security_group
  db_subnet_group_name   = aws_db_subnet_group.default.id
  skip_final_snapshot    = true

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}
