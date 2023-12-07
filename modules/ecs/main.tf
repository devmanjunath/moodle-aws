data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-Cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
