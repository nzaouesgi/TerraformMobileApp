provider "azurerm" {
    version = ">= 2.37.0"
    features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

//API Management
resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.company_name
  publisher_email     = var.company_email

  hostname_configuration {
    management {
      host_name = azurerm_traffic_manager_profile.mobileApp.fqdn
      certificate = ""
    }
  }

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


//APP service Plan
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
//App service
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

//TRAFFIC Manager
//resource "azurerm_traffic_manager_profile" "mobileApp" {
//  name                = "azurermTrafficManagerProfileGaming4Life"
//  resource_group_name = azurerm_resource_group.rg.name
//
//  traffic_routing_method = "Weighted"
//
//  dns_config {
//    relative_name = "azurermTrafficManagerProfileDnsGaming4Life"
//    ttl           = 100
//  }
//
//  monitor_config {
//    protocol                     = "https"
//    port                         = 443
//    path                         = "/"
//    interval_in_seconds          = 30
//    timeout_in_seconds           = 9
//    tolerated_number_of_failures = 3
//  }
//
//  tags = {
//    environment = "Production"
//  }
//}
//
//resource "azurerm_traffic_manager_endpoint" "mobileApp" {
//  name                = "azurerm_traffic_manager_endpoint-gamingForLife"
//  resource_group_name = azurerm_resource_group.rg.name
//  profile_name        = azurerm_traffic_manager_profile.mobileApp.name
//  target              = azurerm_api_management.api_management.public_ip_addresses[0]
//  type                = "externalEndpoints"
//  weight              = 100
//}


resource "azurerm_storage_account" "storage_account" {
  name                     = "storage_account-game4lfe"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "BlobStorage"
  network_rules {
    default_action = "Allow"
  }
}

resource "azurerm_cdn_profile" "example" {
  name                = "cdn-profile-gaming4Life"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "example" {
  name                = "cdn_endpoint-game4Life"
  profile_name        = azurerm_cdn_profile.example.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  origin {
    name      = ""
    host_name = "www.contoso.com"
  }
}
