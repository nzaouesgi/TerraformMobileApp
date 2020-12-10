//APP service Plan
resource "azurerm_app_service_plan" "api_service_plan" {
  name                 = var.app_service_plan_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  kind                 = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

//App service
resource "azurerm_app_service" "api" {

  name                = var.app_service_name
  location            = azurerm_app_service_plan.api_service_plan.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.api_service_plan.id
  https_only          = true

  site_config {
    ftps_state = "Disabled"
    app_command_line = ""
    linux_fx_version = "DOCKER|vad1mo/hello-world-rest"
    always_on   = true
  }

  app_settings = {
    "DATABASE_USER" = var.database_administrator_login
    "DATABASE_PASSWORD" = var.database_administrator_password
    "DATABASE_HOST" = var.database_host
  }
}
