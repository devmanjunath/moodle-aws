variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
}

variable "rds_config" {
  type = object({
    instance_type = string
    storage       = number
  })
}

variable "ec2_config" {
  type = object({
    image_id      = string
    instance_type = string
    users         = number
  })

}

variable "container_config" {
  type = object(
    { moodle = object({
      name   = string
      cpu    = number
      memory = number
      portMappings = list(
        object({
          containerPort = number
          hostPort      = number
        })
      )
      })
  })
}

variable "ecs_environment" {
  type = map(string)
}
