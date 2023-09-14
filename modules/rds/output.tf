output "db_endpoint" {
  value = aws_rds_cluster_instance.cluster_instances.endpoint
}

output "db_username" {
  value = aws_rds_cluster.aurora_serverless.master_username
}

output "db_password" {
  value     = aws_rds_cluster.aurora_serverless.master_password
  sensitive = true
}
