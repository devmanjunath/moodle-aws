resource "aws_ecs_task_definition" "task_definition" {
  # depends_on               = [null_resource.build_docker_image]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  skip_destroy             = true
  container_definitions = jsonencode([{
    memory       = var.container_config["memory"]
    cpu          = var.container_config["cpu"]
    portMappings = var.container_config["portMappings"]
    essential    = true
    environment  = var.container_environments
    # mountPoints = [
    #   {
    #     containerPath = "/var/www/html/moodledata",
    #     sourceVolume  = "${var.name}-volume"
    #   }
    # ],
    name = var.container_config["name"],
    # image = "${aws_ecr_repository.repo.repository_url}:latest"
    image = "bitnami/moodle:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "${var.name}"
        awslogs-create-group  = "true"
        awslogs-region        = "ap-south-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
  # volume {
  #   name = "${var.name}-volume"

  #   efs_volume_configuration {
  #     transit_encryption = "ENABLED"
  #     file_system_id     = var.efs_id
  #     authorization_config {
  #       iam             = "ENABLED"
  #       access_point_id = var.efs_access_point_id

  #     }
  #   }
  # }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  cpu                = var.container_config["cpu"]
  memory             = var.container_config["memory"]
  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn
}
