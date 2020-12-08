resource "azurerm_traffic_manager_profile" "mobileApp" {
  name                = "azurermTrafficManagerProfileGaming4Life"
  resource_group_name = var.resource_group_name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "azurermTrafficManagerProfileDnsGaming4Life"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "https"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_traffic_manager_endpoint" "mobileApp" {
  name                = "azurerm_traffic_manager_endpoint-gamingForLife"
  resource_group_name = var.resource_group_name
  profile_name        = azurerm_traffic_manager_profile.mobileApp.name
  target              = var.target
  type                = "externalEndpoints"
  weight              = 100
}
