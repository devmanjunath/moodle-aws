variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = object({
    HOST_NAME       = string
    DB_HOST         = string
    DB_USER         = string
    DB_PASS         = string
    SITE_NAME       = string
    SHORT_SITE_NAME = string
    ADMIN_USER      = string
    ADMIN_PASS      = string
  })
}
