resource "aws_cloudwatch_log_group" "this" {
  name         = "/aws/ecs/${lower(var.name)}-logs"
  skip_destroy = false
}
