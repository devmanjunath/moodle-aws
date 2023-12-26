output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_username" {
  value = aws_db_instance.this.username
}

output "db_password" {
  value     = aws_db_instance.this.password
  sensitive = true
}

output "db_snapshot_exists" {
  value = data.external.rds_final_snapshot_exists.result.db_exists
}
