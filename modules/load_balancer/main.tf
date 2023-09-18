resource "aws_lb" "this" {
  internal           = "false"
  name               = lower("${var.name}-alb")
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}
