resource "aws_ecs_service" "ecs_service" {
  depends_on      = [aws_ecs_task_definition.task_definition]
  name            = lower("${var.name}-service")
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = var.security_group
    subnets          = var.subnets
  }

  load_balancer {
    container_name   = var.container_config["name"]
    container_port   = "8443"
    target_group_arn = var.target_group_arn
  }
}
