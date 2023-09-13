resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-Cluster"
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = var.name
      }
    }
  }
}
