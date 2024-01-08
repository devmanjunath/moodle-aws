resource "aws_launch_template" "this" {
  count         = var.environment == "prod" ? 1 : 0
  name_prefix   = "${lower(var.name)}-template"
  image_id      = data.aws_ami.this.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${lower(var.name)}-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}

resource "aws_autoscaling_group" "this" {
  count               = var.environment == "prod" ? 1 : 0
  vpc_zone_identifier = var.subnets
  desired_capacity    = var.instance_count
  max_size            = var.instance_count
  min_size            = var.instance_count
  target_group_arns   = [var.load_balancer_id]

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}
