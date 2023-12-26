resource "random_password" "DatabaseMasterPassword" {
  length           = 16
  special          = true
  override_special = "!#$%^*()-=+_?{}|"
}


resource "aws_db_instance" "this" {
  engine                    = "mysql"
  identifier                = lower(var.name)
  allocated_storage         = var.storage
  engine_version            = "8.0.35"
  instance_class            = var.instance_type
  username                  = "admin"
  db_subnet_group_name      = aws_db_subnet_group.default.id
  password                  = random_password.DatabaseMasterPassword.result
  vpc_security_group_ids    = var.security_group
  skip_final_snapshot       = false
  publicly_accessible       = false
  db_name                   = "moodle"
  final_snapshot_identifier = "${var.name}-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}
