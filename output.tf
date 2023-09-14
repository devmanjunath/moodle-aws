output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_username" {
  value = module.rds.db_username
}

output "db_password" {
  value     = module.rds.db_password
  sensitive = true
}
