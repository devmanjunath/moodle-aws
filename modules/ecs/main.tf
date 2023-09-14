resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-Cluster"
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}
