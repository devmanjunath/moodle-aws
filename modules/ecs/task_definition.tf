data "template_file" "task_definition" {
  template = file("${path.module}/task_definition.tpl")

  vars = {
    memory         = var.container_config["memory"]
    host_port      = var.container_config["portMappings"][0]["hostPort"]
    container_port = var.container_config["portMappings"][0]["containerPort"]
    name           = var.container_config["name"]
    image          = data.aws_ecr_repository.repo.repository_url
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "bridge"
  skip_destroy             = true
  container_definitions = jsonencode([{
    memory = var.container_config["memory"],
    portMappings = [
      {
        hostPort      = var.container_config["portMappings"][0]["hostPort"]
        containerPort = var.container_config["portMappings"][0]["containerPort"],
        protocol      = "tcp"
      }
    ],
    essential = true,
    environment = [
      {
        name  = "MOODLE_DATABASE_SERVER",
        value = var.container_environments["MOODLE_DATABASE_SERVER"]
      },
      {
        name  = "MOODLE_DATABASE_NAME",
        value = var.container_environments["MOODLE_DATABASE_NAME"]
      },
      {
        name  = "MOODLE_DATABASE_USERNAME",
        value = var.container_environments["MOODLE_DATABASE_USERNAME"]
      },
      {
        name  = "MOODLE_DATABASE_PASSWORD",
        value = var.container_environments["MOODLE_DATABASE_PASSWORD"]
      },
      {
        name  = "MOODLE_HOST",
        value = var.container_environments["MOODLE_HOST"]
      },
      {
        name  = "MOODLE_CACHE_HOST",
        value = var.container_environments["MOODLE_CACHE_HOST"]
      }
    ]
    mountPoints = [
      {
        containerPath = "/var/www/moodledata",
        sourceVolume  = "efs-Test"
      }
    ],
    name  = var.container_config["name"],
    image = "480174253711.dkr.ecr.ap-south-2.amazonaws.com/test-drive:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "nginx"
        awslogs-create-group  = "true"
        awslogs-region        = "ap-south-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
  volume {
    name = "efs-Test"
    efs_volume_configuration {
      file_system_id = var.efs_id
    }
  }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  cpu                = 1024
  memory             = 3000
  task_role_arn      = "arn:aws:iam::480174253711:role/MoodleTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::480174253711:role/MoodleTaskExecutionRole"
}
