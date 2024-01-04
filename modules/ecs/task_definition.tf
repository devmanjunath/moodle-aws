resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_capacity_provider.this]
  family                   = var.name
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  skip_destroy             = false
  container_definitions = jsonencode([
    {
      cpu          = var.container_config["moodle"]["cpu"]
      memory       = var.container_config["moodle"]["memory"]
      portMappings = var.container_config["moodle"]["portMappings"]
      essential    = true
      mountPoints = [
        {
          containerPath = "/var/moodledata",
          sourceVolume  = "${var.name}-volume"
        }
      ],
      name  = var.container_config["moodle"]["name"],
      image = "${var.moodle_image_uri}:latest"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.container_config["moodle"]["name"]
          awslogs-create-group  = "true"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
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
  cpu                = var.container_config["moodle"]["cpu"]
  memory             = var.container_config["moodle"]["memory"]
  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn
}
