variable "name" {
  type = string
}

variable "acm_arn" {
  type = string
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

variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}
