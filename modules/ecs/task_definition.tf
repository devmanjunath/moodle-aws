resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_capacity_provider.this, null_resource.build_docker_image]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  skip_destroy             = true
  container_definitions = jsonencode([{
    portMappings = var.container_config["portMappings"]
    essential    = true
    environment = [
      for key, value in var.container_environments : {
        name  = key
        value = value
      }
    ]
    mountPoints = [
      {
        containerPath = "/bitnami/moodledata",
        sourceVolume  = "${var.name}-volume"
      }
    ],
    name  = var.container_config["name"],
    image = "${aws_ecr_repository.repo.repository_url}:latest"
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
  volume {
    name = "${var.name}-volume"

    efs_volume_configuration {
      transit_encryption = "ENABLED"
      file_system_id     = var.efs_id
      authorization_config {
        iam             = "ENABLED"
        access_point_id = var.efs_access_point_id
      }
    }
  }
  cpu                = var.container_config["cpu"]
  memory             = var.container_config["memory"]
  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn
}
