variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
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
      environment = map(string)
      })
      nginx = object({
        name   = string
        cpu    = number
        memory = number
        portMappings = list(
          object({
            containerPort = number
            hostPort      = number
          })
        )
        environment = map(string)
      })
  })
}
