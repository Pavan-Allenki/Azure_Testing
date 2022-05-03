resource "azurerm_mysql_server" "example" {
  name                = "example-mysqlserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ssl_enforcement_enabled           = false
  ssl_minimal_tls_version_enforced  = "1.2"
}
