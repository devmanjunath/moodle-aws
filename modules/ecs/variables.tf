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

variable "efs_arn" {
  type = string
}

variable "efs_access_point_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "efs_access_point_id" {
  type = string
}

variable "asg_arn" {
  type = string
}

variable "nginx_image_uri" {
  type = string
}

variable "moodle_image_uri" {
  type = string
}