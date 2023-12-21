variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
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

variable "environment" {
  type = object({
    moodle = map(string)
  })
}
