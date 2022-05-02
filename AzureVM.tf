resource "azurerm_managed_disk" "example" {
  name                 = var.disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  tags = var.common_tags
}
resource "azurerm_virtual_machine" "my-linux-vm" {
  name                  = "my-linux-vm"
  location              = "California"
  resource_group_name   = "some-rg"
  network_interface_ids = ["some-id"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "my-os-disk"
    caching           = "ReadWrite"
    os_type           = "Linux"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    managed_disk_id   = azurerm_managed_disk.my-managed-disk.id
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_key_vault" "example" {
  name                        = "des-example-keyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

resource "azurerm_key_vault_key" "example" {
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

