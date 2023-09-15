data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")

  vars = {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-00cd879d458b963ec"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = var.security_group
  user_data            = data.template_file.user_data.rendered
  instance_type        = "i3.large"
  key_name             = "EFS-TEST"
}

resource "aws_autoscaling_group" "asg" {
  depends_on = [ aws_lb_target_group.target_group ]
  name                 = "${var.name}-asg"
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns = [aws_lb_target_group.target_group.arn]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
