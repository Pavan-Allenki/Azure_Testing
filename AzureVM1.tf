resource "azurerm_virtual_machine" "my-linux" {
  name                  = "my-linux-vm"
  location              = "California"
  resource_group_name   = "some-rg"
  network_interface_ids = ["some-id"]
  vm_size               = "Standard_DS1_v2"

  storage_data_disk {
    create_option = "Empty"
    lun           = 0
    name          = "my-data-disk"
    managed_disk_type = "Standard_LRS"
    managed_disk_id = azurerm_managed_disk.my-managed-disk.id
  }
  
  storage_os_disk {
    name              = "my-os-disk"
    caching           = "ReadWrite"
    os_type           = "Linux"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    managed_disk_id = ""
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_managed_disk" "my-managed-disk" {
  create_option        = "Empty"
  location             = "California"
  name                 = "my-managed-disk-1"
  resource_group_name  = "some-rg"
  storage_account_type = "Standard_LRS"
  disk_encryption_set_id = azurerm_disk_encryption_set.example.id
}

resource "azurerm_key_vault" "example1" {
  name                        = "des-example-keyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = false
  purge_protection_enabled    = true
}

resource "azurerm_key_vault_key" "example1" {
  name         = "des-example-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

