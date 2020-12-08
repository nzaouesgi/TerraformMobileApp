resource "azurerm_storage_account" "storage_account" {
  name                     = "storageaccountgame4life"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "BlobStorage"

  allow_blob_public_access = true

  network_rules {
    default_action = "Allow"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "storagecontainergamefourlife"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "blob"
}
