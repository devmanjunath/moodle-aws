data "template_file" "task_definition" {
  template = file("${path.module}/task_definition.tpl")

  vars = {
    memory         = var.container_config["memory"]
    host_port      = var.container_config["portMappings"][0]["hostPort"]
    container_port = var.container_config["portMappings"][0]["containerPort"]
    name           = var.container_config["name"]
    image          = aws_ecr_repository.repo.repository_url
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  depends_on               = [aws_ecs_cluster_capacity_providers.example]
  family                   = "${var.name}-Definition"
  requires_compatibilities = ["EC2"]
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
    mountPoints = [
      {
        containerPath = "/var/www",
        sourceVolume  = "efs-Test"
      }
    ],
    name  = var.container_config["name"],
    image = "480174253711.dkr.ecr.ap-south-2.amazonaws.com/test-drive:latest"
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
