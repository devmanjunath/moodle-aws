variable "name" {
  type = string
}

variable "region" {
  type = string
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

variable "container_config" {
  type = any
}

variable "efs_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "container_environments" {
  type = object({
    MOODLE_HOST              = string
    MOODLE_DATABASE_SERVER   = string
    MOODLE_DATABASE_NAME     = string
    MOODLE_DATABASE_USERNAME = string
    MOODLE_DATABASE_PASSWORD = string
    MOODLE_CACHE_HOST        = string
  })
}
