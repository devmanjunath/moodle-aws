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
          ["if [ '${var.environment["moodle"]["SKIP_BOOTSTRAP"]}' = 'no' ];",
            "then php /var/www/html/moodle/admin/cli/install.php",
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
            "--adminpass=admin123",
            "&& sed -i \"/$$CFG->directorypermissions = 0777;/a \\$$CFG->xsendfile = 'X-Accel-Redirect';\\n\\$$CFG->xsendfilealiases = array(\\n\\t'/dataroot/' => \\$$CFG->dataroot\\n);\" /var/www/html/moodle/config.php && chmod 0644 /var/www/html/moodle/config.php;",
            "else echo \"hello world\"; fi \n",
            "grep",
            "-qe",
            "'date.timezone = local_timezone'",
            "/usr/local/etc/php/conf.d/security.ini",
            "|| echo 'date.timezone = local_timezone' >> /usr/local/etc/php/conf.d/security.ini; sh /etc/entrypoint.sh"
        ])
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
