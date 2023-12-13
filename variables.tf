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
      })
  })
}

variable "environment" {
  type = object({
    moodle = map(string)
    nginx  = map(string)
  })
}
