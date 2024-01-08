resource "aws_lb_target_group" "this" {
  name             = "${var.name}-tg"
  port             = "443"
  protocol         = "HTTPS"
  target_type      = "instance"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"

  health_check {
    path                = "/"
    port                = "443"
    protocol            = "HTTPS"
    interval            = "30"
    timeout             = "5"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
