variable "name" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "cluster_arn" {
  type = string
}

variable "service_name" {
  type    = string
  default = ""
}

variable "environment" {
  type = object({
    HOST_NAME  = string
    CACHE_HOST = string
    DB_HOST    = string
    DB_USER    = string
    DB_PASS    = string
    SITE_NAME  = string
    ADMIN_USER = string
    ADMIN_PASS = string
  })
}

variable "pass_role" {
  type = string
}
