variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
}

variable "container_config" {
  type = object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    portMappings = list(object({
      containerPort = number
      hostPort      = number
    }))
  })
}

variable "container_environment" {
  type = map(string)
}
