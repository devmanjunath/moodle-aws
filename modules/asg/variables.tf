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

variable "target_group_arn" {
  type = string
}
