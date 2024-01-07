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
    users         = number
    key_name      = string
  })
}

variable "cache_config" {
  type = object({
    instance_type = string
  })
}
