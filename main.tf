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
  path                = ""

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
}