variable "app_service_plan_name" {
  type    = string
  default = "gaming4lifeplan"
  description = "Name for the API service plan"
}

variable "app_service_name" {
  type    = string
  default = "gaming4life"
  description = "Our API resource name"
}

variable "resource_group_name" {
  type = string
  description = "main resource_group name"
}


variable "location" {
  type = string
  description = "location for this resource"
}

variable "database_administrator_login" {
  type = string
  description = "login of the database administrator"
}

variable "database_administrator_password" {
  type = string
  description = "password of the database administrator"
}

variable "database_host" {
  type = string
  description = "host of the database"
}
