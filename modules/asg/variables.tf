variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "image_id" {
  type    = string
  default = "ami-0345c0581a1b3637a"
}

variable "instance_type" {
  type    = string
  default = "m5.large"
}

variable "instance_count" {
  type    = number
  default = "300"
}

variable "environment" {
  type = string
}

variable "load_balancer_id" {
  type = string
}
