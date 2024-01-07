variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "VPC Created By Terraform"
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "cache.t3.medium"
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
