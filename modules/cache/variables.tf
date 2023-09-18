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
