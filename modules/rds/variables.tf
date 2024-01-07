variable "name" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "storage" {
  type = string
}

variable "publicly_accessible" {
  type = bool
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
