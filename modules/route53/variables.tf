variable "domain_name" {
  type = string
}

variable "acm_arn" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "domain_validation_options" {
  type = any
}
