resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_capacity_provider.this]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  skip_destroy             = true
  container_definitions = jsonencode([
    {
      cpu          = var.container_config["moodle"]["cpu"]
      memory       = var.container_config["moodle"]["memory"]
      portMappings = var.container_config["moodle"]["portMappings"]
      essential    = true
      environment = [
        for key, value in var.environment["moodle"] : {
          name  = key
          value = value
        }
      ]
      command = [
        "/bin/sh",
        "-c",
        "/opt/entrypoint.sh",
        "-s true",
        "-h '${var.environment["moodle"]["HOST_NAME"]}'",
        "-t 'auroramysql'",
        "-d '${var.environment["moodle"]["DB_HOST"]}''",
        "-a 'moodle'",
        "-f '${var.environment["moodle"]["DB_USER"]}'",
        "-p '${var.environment["moodle"]["DB_PASSWORD"]}'",
        "-y '${var.environment["moodle"]["FULL_SITE_NAME"]}'",
        "-q '${var.environment["moodle"]["ADMIN_USER"]}'",
        "-e '${var.environment["moodle"]["ADMIN_PASSWORD"]}'"
      ]
      mountPoints = [
        {
          containerPath = "/var/www/moodledata",
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
