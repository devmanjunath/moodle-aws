variable "region" {
  type    = string
  default = "ap-south-2"
}

variable "project" {
  type    = string
  default = "Test-Drive"
}

variable "container_config" {
  type = object({
    name   = string
    image  = string
    memory = number
    portMappings = list(object({
      containerPort = number
      hostPort      = number
    }))
  })
}
