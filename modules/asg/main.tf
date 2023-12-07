resource "aws_launch_template" "this" {
  name_prefix   = "${lower(var.name)}-template"
  image_id      = "ami-0345c0581a1b3637a"
  instance_type = "t3.large"

  key_name               = var.key_pair
  vpc_security_group_ids = var.security_group
  iam_instance_profile {
    name = "ecsInstanceRole"
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
  vpc_zone_identifier = var.subnets
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
