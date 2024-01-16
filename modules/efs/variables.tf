variable "name" {
  type = string
}

variable "subnets_to_mount" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
