resource "random_password" "DatabaseMasterPassword" {
  length           = 16
  special          = true
  override_special = "!#$%^*()-=+_?{}|"
}

data "aws_db_snapshot" "latest_snapshot" {
  db_instance_identifier = var.name
  most_recent            = true
}

resource "aws_db_instance" "this" {
  engine                    = "mysql"
  identifier                = lower(var.name)
  allocated_storage         = var.storage
  engine_version            = "8.0.35"
  instance_class            = var.instance_type
  db_subnet_group_name      = aws_db_subnet_group.default.id
  vpc_security_group_ids    = var.security_group
  skip_final_snapshot       = false
  publicly_accessible       = var.publicly_accessible
  db_name                   = "moodle"
  final_snapshot_identifier = "${var.name}-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  copy_tags_to_snapshot     = true
  snapshot_identifier       = try(data.aws_db_snapshot.latest_snapshot.id, null)
}
