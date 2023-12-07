variable "name" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}
