resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  resource_group_name      = "example-resources"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = false

  tags = {
    environment = "staging"
  }
}
