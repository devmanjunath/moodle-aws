data "external" "rds_final_snapshot_exists" {
  program = [
    "./check-snapshot.sh",
    "db-instance-${terraform.workspace}"
  ]
}


data "aws_db_snapshot" "latest_snapshot" {
  count                  = data.external.rds_final_snapshot_exists.result.db_exists ? 1 : 0
  db_instance_identifier = "db-instance-id"
  most_recent            = true
}
