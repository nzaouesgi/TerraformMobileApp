variable "rg_name" {
  type    = string
  default = "TerraformMobileApp"
  description = "Name for the main resource group"
}

variable "rg_location" {
  type    = string
  default = "West Europe"
  description = "Location for the main resource group"
}

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

variable "api_management_name" {
  type    = string
  default = "gaming4lifeapim"
  description = "Name of our API management resource"
}

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
