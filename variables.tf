variable "api_version" {
  type    = string
  default = "1"
  description = "This is used by the API management resource."
}

variable "mysql_user" {
  type = string
  description = "Admin user for MySQL"
}

variable "mysql_password" {
  type = string
  description = "Admin password for MySQL"
}
