locals {
  parameter_prefix = replace(lower(var.project), " ", "-")
}

resource "aws_ssm_parameter" "rds_config" {
  name  = "/${local.parameter_prefix}/env/rds-config"
  description = "Database configuration for ${lower(var.project)}"
  type  = "String"
  value = jsonencode(var.rds_config)
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "container_config" {
  name  = "/${local.parameter_prefix}/env/container-config"
  description = "Container configuration for ${lower(var.project)}"
  type  = "String"
  value = jsonencode(var.container_config)
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ecs_environment" {
  name  = "/${local.parameter_prefix}/env/ecs-environment"
  description = "ECS environment for ${lower(var.project)}"
  type  = "String"
  value = jsonencode(var.ecs_environment)
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ec2_config" {
  name  = "/${local.parameter_prefix}/env/ec2-config"
  description = "EC2 configuration for ${lower(var.project)}"
  type  = "String"
  value = jsonencode(var.ec2_config)
  lifecycle {
    ignore_changes = [value]
  }
}
