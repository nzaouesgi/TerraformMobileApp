output "database_administrator_login" {
  value = azurerm_mysql_server.mysql.administrator_login
}

output "database_administrator_password" {
  value =azurerm_mysql_server.mysql.administrator_login_password
}

output "database_host" {
  value = azurerm_mysql_server.mysql.fqdn
}
