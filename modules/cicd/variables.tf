variable "name" {
  type = string
}

variable "environment_variables" {
  type = list(object({
    name  = string,
    value = string,
    type  = string
  }))
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}