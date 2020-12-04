provider "azurerm" {
    version = ">= 2.37.0"
    features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.company_name
  publisher_email     = var.company_email
  sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "api_management_api" {
  
  name                = "${var.api_management_name}-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api_management.name
  revision            = var.api_version
  display_name        = "Gaming4Life API"

  # No need for a subscription (public API)
  subscription_required = false
  
  # No sufix since we have only one API to expose.
  path                  = ""

  # Only HTTPS between gateway and API.
  protocols           = [ "https" ]

  service_url = "https://${azurerm_app_service.api.default_site_hostname}"
}

resource "azurerm_api_management_api_operation" "api_hello_world_endpoint" {
  operation_id        = "hello-world"
  api_name            = azurerm_api_management_api.api_management_api.name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = "Hello world endpoint"
  method              = "GET"
  url_template        = "*"
  description         = "A mock endpoint for our terraform app."
}

resource "azurerm_app_service_plan" "api_service_plan" {
  name                 = var.app_service_plan_name
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  kind                 = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "api" {
  
  name                = var.app_service_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.api_service_plan.id
  https_only          = true
  
  site_config {
    ftps_state = "Disabled"
    app_command_line = ""
    linux_fx_version = "DOCKER|vad1mo/hello-world-rest"
    always_on   = true
  }

  app_settings = {
    "DATABASE_USER" = azurerm_mysql_server.mysql.administrator_login
    "DATABASE_PASSWORD" = azurerm_mysql_server.mysql.administrator_login_password
    "DATABASE_HOST" = azurerm_mysql_server.mysql.fqdn
  }
}

# MYSQL
resource azurerm_mysql_server mysql {
  name                = "gaming4life-mysql-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  administrator_login          = var.my_sql_user
  administrator_login_password = var.my_sql_password

  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
}

# This firewall rule allows MySQL to communicate with other resources such as App services etc...
resource azurerm_mysql_firewall_rule mysql_firewall {
  name                = "gaming4life-mysqlfirewall"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# This is the main application database
resource azurerm_mysql_database database {
  name                = "gaming4life"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
