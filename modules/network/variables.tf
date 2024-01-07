variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "VPC Created By Terraform"
}

variable "environment" {
  type = string
}

variable "public_subnets" {
  type        = map(any)
  description = "No of public subnets to be created"
}

variable "private_subnets" {
  type        = map(any)
  description = "No of private subnets to be created"
}
