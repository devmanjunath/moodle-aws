resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_cluster_capacity_providers.example]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  skip_destroy             = true
  container_definitions    = jsonencode([var.container_config])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  //task_role_arn      = "arn:aws:iam::489791930594:role/PokedexECSTaskRole"
  //execution_role_arn = "arn:aws:iam::489791930594:role/PokedexECSTaskRole"
}
