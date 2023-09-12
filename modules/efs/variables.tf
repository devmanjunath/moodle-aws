variable "name" {
  type = string
}

variable "subnets_to_mount" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}
