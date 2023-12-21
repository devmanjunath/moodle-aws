variable "name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "image_id" {
  type    = string
  default = "ami-0345c0581a1b3637a"
}

variable "instance_type" {
  type    = string
  default = "m5.large"
}

variable "users" {
  type    = number
  default = "300"
}
