resource "aws_lb_target_group" "this" {
  name             = "${var.name}-tg"
  port             = "80"
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = "30"
    timeout             = "5"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-310"
  }

  lifecycle {
    create_before_destroy = true
  }
}
