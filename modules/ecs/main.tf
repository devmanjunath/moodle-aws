data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "this" {
  depends_on = [aws_ecs_task_definition.task_definition]
  name       = "${var.name}-Cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
