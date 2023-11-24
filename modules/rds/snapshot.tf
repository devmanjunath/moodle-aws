data "external" "rds_final_snapshot_exists" {
  program = [
    "${path.module}/check-snapshot.sh",
    "${var.name}-db"
  ]
  query = {
    region = var.region
  }
}


data "aws_db_cluster_snapshot" "latest_snapshot" {
  count                 = data.external.rds_final_snapshot_exists.result.db_exists ? 1 : 0
  db_cluster_identifier = "${var.name}-db"
  most_recent           = true
}
