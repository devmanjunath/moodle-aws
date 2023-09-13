variable "name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "container_config" {
  type = any
}
