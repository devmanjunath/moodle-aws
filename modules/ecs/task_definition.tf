resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_capacity_provider.this]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  skip_destroy             = true
  container_definitions = jsonencode([
    {
      portMappings = var.container_config["moodle"]["portMappings"]
      essential    = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -fk http://localhost || exit 1"]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 300
      }
      environment = [
        for key, value in var.environment["moodle"] : {
          name  = key
          value = value
        }
      ]
      command = ["echo 'Hello World'"]
      mountPoints = [
        {
          containerPath = "/var/www/moodle-data",
          sourceVolume  = "${var.name}-volume"
        },
        {
          containerPath = "/var/www/html",
          sourceVolume  = "moodle-shared"
        }
      ],
      name  = var.container_config["moodle"]["name"],
      image = "${var.moodle_image_uri}:latest"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "${var.name}"
          awslogs-create-group  = "true"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      dependsOn = [{
        containerName = "${var.container_config["moodle"]["name"]}"
        condition     = "HEALTHY"
      }]
      portMappings = var.container_config["nginx"]["portMappings"]
      essential    = true
      environment = [
        for key, value in var.environment["nginx"] : {
          name  = key
          value = value
        }
      ]
      mountPoints = [
        {
          containerPath = "/var/www/html",
          sourceVolume  = "moodle-shared"
        }
      ],
      name  = var.container_config["nginx"]["name"],
      image = "${var.nginx_image_uri}:latest"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "${var.name}"
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
  volume {
    name = "moodle-shared"
    docker_volume_configuration {
      scope  = "task"
      driver = "local"
    }
  }
  cpu                = var.container_config["moodle"]["cpu"]
  memory             = var.container_config["nginx"]["memory"]
  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn
}
