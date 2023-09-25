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

output lb_dns_name{
  value = module.load_balancer.dns_name
}