resource "azurerm_storage_account" "mock" {
  #count                    = var.env_short == "d" ? 1 : 0
  name                     = "mocknodo"
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags

  #network_rules {
  #  default_action             = "Deny"
  #  virtual_network_subnet_ids = [azurerm_subnet.apim.id]
  #}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "mock" {
  #count                 = var.env_short == "d" ? 1 : 0
  name                  = "mocknodo"
  storage_account_name  = azurerm_storage_account.mock.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "response_1" {
  #count                  = var.env_short == "d" ? 1 : 0
  name                   = "4585626.json" # File name on storage container
  storage_account_name   = azurerm_storage_account.mock.name
  storage_container_name = azurerm_storage_container.mock.name
  type                   = "Block"
  source                 = "templates/4585625.json" # Local file name
}

