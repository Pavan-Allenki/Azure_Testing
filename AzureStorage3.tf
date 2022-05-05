resource "azurerm_resource_group" "example33" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example39" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = true

  network_rules {
    bypass                  = ["default"]
  }
}
