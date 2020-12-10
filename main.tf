provider "azurerm" {
    version = ">= 2.37.0"
    features {}
}

//Resooure group
module "resource_group" {
  source = "./resource-group"
}

//Mysql Database
module "mysql_database" {
  source = "./mysql-database"
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
  mysql_password = var.mysql_password
  mysql_user = var.mysql_user
}

//App Service
module "api" {
  source = "./app-service"
  database_administrator_login = module.mysql_database.database_administrator_login
  database_administrator_password = module.mysql_database.database_administrator_password
  database_host = module.mysql_database.database_host
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
}

//API Management
module "api_management" {
  source = "./api-management"
  api_host_name = module.api.host_name
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
  api_version = var.api_version
}

//TRAFFIC Manager
module "traffic_manager" {
  source = "./traffic-manager"
  resource_group_name = module.resource_group.name
  target = module.api_management.public_ip_addresses[0]
}


//Storage Account
module "storage_account" {
  source = "./storage-account"
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
}

//CDN
module "cdn_profile" {
  source = "./cdn"
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
  storage_account_host_name = module.storage_account.host_name
}


