variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = "Test-Drive"
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = var.environment == "dev" || var.environment == "prod"
    error_message = "The environment must either be dev or prod"
  }
}

variable "domain_name" {
  type = string
}

variable "rds_config" {
  type = object({
    instance_type = string
    storage       = number
  })
}

variable "ec2_config" {
  type = object({
    image_id      = string
    instance_type = string
    key_name      = string
  })
}

variable "cache_config" {
  type = object({
    instance_type = string
  })
}

variable "users" {
  type    = number
  default = 100
  validation {
    condition     = contains([100, 250, 500, 1000, 2000, 3000, 4000, 5000], var.users)
    error_message = "Valid values for the total number of users are:(100,250,500,1000,2000,3000,4000,5000)"
  }
}
