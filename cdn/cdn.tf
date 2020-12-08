resource "azurerm_cdn_profile" "example" {
  name                = "cdn-profile-gaming4Life"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "example" {
  name                = "cdnEndpointGame4Life"
  profile_name        = azurerm_cdn_profile.example.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin {
    name      = "origin1"
    host_name = var.storage_account_host_name
  }
  origin_host_header = var.storage_account_host_name

}
