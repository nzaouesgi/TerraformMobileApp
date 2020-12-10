variable "mysql_user" {
  type = string
  description = "Admin user for MySQL"
}

variable "mysql_password" {
  type = string
  description = "Admin password for MySQL"
}

variable "resource_group_name" {
  type = string
  description = "main resource_group name"
}


variable "location" {
  type = string
  description = "location for this resource"
}
