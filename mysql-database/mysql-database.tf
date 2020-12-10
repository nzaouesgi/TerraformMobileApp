# MYSQL
resource azurerm_mysql_server mysql {
  name                = "gaming4life-mysql-server"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  administrator_login          = var.mysql_user
  administrator_login_password = var.mysql_password

  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
}

# This firewall rule allows MySQL to communicate with other resources such as App services etc...
resource azurerm_mysql_firewall_rule mysql_firewall {
  name                = "gaming4life-mysqlfirewall"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# This is the main application database
resource azurerm_mysql_database database {
  name                = "gaming4life"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

}

resource "azurerm_mysql_configuration" "mysql_capture_mode" {
  name                = "query_store_capture_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  value               = "ALL"
}

resource "azurerm_mysql_configuration" "mysql_wait_sampling_capture_mode" {
  name                = "query_store_wait_sampling_capture_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  value               = "ALL"
}
