variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
}

variable "container_config" {
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    portMappings = list(object({
      containerPort = number
      hostPort      = number
    }))
    environment = list(any)
  }))
}

variable "container_environment" {
  type = map(string)
}
