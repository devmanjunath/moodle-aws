resource "aws_ecs_service" "this" {
  depends_on             = [aws_ecs_task_definition.task_definition]
  name                   = lower("${var.name}-service")
  cluster                = aws_ecs_cluster.this.id
  task_definition        = aws_ecs_task_definition.task_definition.arn
  desired_count          = 1
  force_new_deployment   = true
  enable_execute_command = true
  launch_type            = "FARGATE"

  network_configuration {
    security_groups = var.security_group
    subnets         = var.subnets
    assign_public_ip = true
  }

  # ordered_placement_strategy {
  #   type  = "spread"
  #   field = "attribute:ecs.availability-zone"
  # }

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "memory"
  # }

  # capacity_provider_strategy {
  #   capacity_provider = aws_ecs_capacity_provider.this.name
  #   weight            = 100
  # }

  load_balancer {
    container_name   = var.container_config["moodle"]["name"]
    container_port   = "443"
    target_group_arn = var.target_group_arn
  }
}
