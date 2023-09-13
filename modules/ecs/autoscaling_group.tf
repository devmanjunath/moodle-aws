resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-0ee5ef2135fd3646b"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = var.security_group
  user_data            = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config"
  instance_type        = "i3.large"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
