resource "random_password" "DatabaseMasterPassword" {
  length           = 16
  special          = true
  override_special = "!#$%^*()-=+_?{}|"
}

resource "aws_rds_cluster" "aurora_serverless" {
  depends_on                       = [aws_rds_cluster_parameter_group.default]
  cluster_identifier               = lower("${var.name}-db")
  engine                           = "aurora-mysql"
  master_username                  = "admin"
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.default.name
  db_instance_parameter_group_name = aws_rds_cluster_parameter_group.default.name
  master_password                  = random_password.DatabaseMasterPassword.result
  vpc_security_group_ids           = var.security_group
  db_subnet_group_name             = aws_db_subnet_group.default.id
  engine_version                   = "5.7.mysql_aurora.2.11.2"
  skip_final_snapshot              = true
}
