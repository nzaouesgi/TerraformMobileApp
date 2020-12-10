//API Management
resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.company_name
  publisher_email     = var.company_email
  sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "api_management_api" {

  name                = "${var.api_management_name}-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.api_management.name
  revision            = var.api_version
  display_name        = "Gaming4Life API"

  # No need for a subscription (public API)
  subscription_required = false

  # No sufix since we have only one API to expose.
  path                  = ""

  # Only HTTPS between gateway and API.
  protocols           = [ "https" ]

  service_url = "https://${var.api_host_name}"
}

resource "azurerm_api_management_api_operation" "api_hello_world_endpoint" {
  operation_id        = "hello-world"
  api_name            = azurerm_api_management_api.api_management_api.name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = var.resource_group_name
  display_name        = "Hello world endpoint"
  method              = "GET"
  url_template        = "*"
  description         = "A mock endpoint for our terraform app."
}
