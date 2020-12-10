variable "api_management_name" {
  type    = string
  default = "gaming4lifeapim"
  description = "Name of our API management resource"
}

variable "resource_group_name" {
  type = string
  description = "main resource_group name"
}


variable "location" {
  type = string
  description = "location for this resource"
}

variable "company_name" {
  type    = string
  default = "ESGI"
  description = "This is used for the API management resource"
}

variable "company_email" {
  type    = string
  default = "S8768765785544@outlook.com"
  description = "This is used for the API management resource"
}

variable "api_version" {
  type    = string
  default = "1"
  description = "This is used by the API management resource."
}

variable "api_host_name" {
  type = string
  description = "Host name of the API"
}
