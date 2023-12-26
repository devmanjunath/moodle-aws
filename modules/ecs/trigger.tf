module "triggers" {
  depends_on   = [aws_ecs_cluster.this]
  source       = "./triggers"
  name         = var.name
  cluster_arn  = aws_ecs_cluster.this.arn
  cluster_name = aws_ecs_cluster.this.name
  service_name = lower("${var.name}-service")
  pass_role = aws_iam_role.this.arn
  environment = {
    HOST_NAME  = var.environment["moodle"]["HOST_NAME"]
    DB_HOST    = var.environment["moodle"]["DB_HOST"]
    DB_USER    = var.environment["moodle"]["DB_USER"]
    DB_PASS    = var.environment["moodle"]["DB_PASSWORD"]
    SITE_NAME  = var.environment["moodle"]["FULL_SITE_NAME"]
    ADMIN_USER = var.environment["moodle"]["ADMIN_USER"]
    ADMIN_PASS = var.environment["moodle"]["ADMIN_PASSWORD"]
    CACHE_HOST = var.environment["moodle"]["CACHE_HOST"]
  }
}
