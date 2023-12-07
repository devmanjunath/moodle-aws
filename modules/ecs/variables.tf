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

variable "container_environments" {
  type = map(string)
  # List of variables required
  # BITNAMI_DEBUG            = string
  # MOODLE_DATABASE_NAME     = string
  # MOODLE_DATABASE_HOST     = string
  # MOODLE_DATABASE_USER     = string
  # MOODLE_DATABASE_PASSWORD = string
  # MOODLE_DATABASE_TYPE     = string
  # MOODLE_SKIP_BOOTSTRAP    = string
  # MOODLE_SKIP_INSTALL      = string
  # MOODLE_SMTP_HOST         = string
  # MOODLE_SMTP_PORT         = string
  # MOODLE_SMTP_USER         = string
  # MOODLE_SMTP_PASSWORD     = string
  # MOODLE_SSLPROXY          = string
  # MOODLE_HOST              = string
  # MOODLE_USERNAME          = string
  # MOODLE_PASSWORD          = string
  # MOODLE_EMAIL             = string
  # MOODLE_SITE_NAME         = string
}
