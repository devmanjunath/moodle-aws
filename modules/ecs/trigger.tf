module "triggers" {
  depends_on   = [aws_ecs_cluster.this]
  source       = "./triggers"
  name         = var.name
  cluster_arn  = aws_ecs_cluster.this.arn
  cluster_name = aws_ecs_cluster.this.name
  service_name = lower("${var.name}-service")
}
