resource "aws_lb" "loadbalancer" {
  internal           = "false"
  name               = lower("${var.name}-alb")
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_group
}


resource "aws_lb_target_group" "target_group" {
  name     = "http-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "10"
    timeout             = "10"
  }
}

resource "aws_lb_listener" "lb_listener-webservice-https-redirect" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  # default_action {
  #   type = "redirect"
  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

# resource "aws_lb_listener" "lb_listener-webservice-https" {
#   load_balancer_arn = aws_lb.loadbalancer.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.ssl_certificate.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.alb_public_webservice_target_group.id
#   }
# }
