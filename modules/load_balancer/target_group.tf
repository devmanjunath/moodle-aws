resource "aws_lb_target_group" "this" {
  name             = "${var.name}-tg"
  port             = "443"
  protocol         = "HTTPS"
  target_type      = "ip"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    path                = "/"
    protocol            = "HTTPS"
    port                = "8443"
    unhealthy_threshold = "10"
    timeout             = "10"
  }

  lifecycle {
    create_before_destroy = true
  }
}
