output "db_endpoint" {
  value = "db.${var.domain_name}"
}

output "db_username" {
  value = module.rds.db_username
}

output "cache_endpoint" {
  value = "cache.${var.domain_name}"
}

output "smtp_username" {
  value = module.ses.smtp_username
}

output "smtp_password" {
  value     = module.ses.smtp_password
  sensitive = true
}
