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
      command = [
        "/bin/sh",
        "-c",
        join(
          " ",
          ["if [ \"${var.environment["moodle"]["SKIP_BOOTSTRAP"]}\" == \"no\" ];",
            "then php /var/www/html/admin/cli/install.php",
            "--chmod=0777",
            "--non-interactive",
            "--agree-license",
            "--wwwroot=https://${var.environment["moodle"]["HOST_NAME"]}",
            "--dataroot=/var/www/moodledata",
            "--dbtype=auroramysql",
            "--dbhost=${var.environment["moodle"]["DB_HOST"]}",
            "--dbname=moodle",
            "--dbuser=${var.environment["moodle"]["DB_USER"]}",
            "--dbpass=${var.environment["moodle"]["DB_PASSWORD"]}",
            "--fullname='${var.environment["moodle"]["FULL_SITE_NAME"]}'",
            "--shortname='${var.environment["moodle"]["SHORT_SITE_NAME"]}'",
            "--adminuser=admin",
            "--adminpass=admin123;",
            "else mv /var/www/html/config_bak.php /var/www/html/config.php fi; php-fpm"
          ]
        ),
      ]
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
          awslogs-group         = var.container_config["moodle"]["name"]
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
          awslogs-group         = var.container_config["nginx"]["name"]
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
