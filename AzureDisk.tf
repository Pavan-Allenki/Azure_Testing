resource "azurerm_managed_disk" "managed_disk_good_1" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.group.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

 encryption_settings {
   enabled = false
 }
}
