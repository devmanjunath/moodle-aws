resource "aws_ecs_service" "ecs_service" {
  depends_on      = [aws_ecs_task_definition.task_definition]
  name            = lower("${var.name}-service")
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "EC2"
  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_group
  }
}
