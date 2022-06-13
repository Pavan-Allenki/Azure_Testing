resource "azurerm_resource_group" "exampleTDE" {
  name     = "example-resources"
  location = "EastUs"
}

resource "azurerm_sql_server" "exampleTDE" {
  name                         = "mssqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.example.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "production"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Create a key vault with policies for the deployer to create a key & SQL Server to wrap/unwrap/get key
resource "azurerm_key_vault" "exampleTDE" {
  name                        = "example"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Purge",
    ]
  }
  access_policy {
    tenant_id = azurerm_mssql_server.example.identity[0].tenant_id
    object_id = azurerm_mssql_server.example.identity[0].principal_id

    key_permissions = [
      "Get", "WrapKey", "UnwrapKey"
    ]
  }
}

resource "azurerm_key_vault_key" "exampleTDE" {
  name         = "byok"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "unwrapKey",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault.example
  ]
}

resource "azurerm_mssql_server_transparent_data_encryption" "exampleTDE" {
  server_id        = azurerm_mssql_server.example.id
  key_vault_key_id = azurerm_key_vault_key.example.id
}
