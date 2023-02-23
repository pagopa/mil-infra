resource "azurerm_storage_account" "conf" {
  name                     = "milconf"
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = true
  tags                     = var.tags
}

resource "azurerm_storage_container" "acquirer_conf" {
  name                  = "acquirer-conf"
  storage_account_name  = azurerm_storage_account.conf.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "acquirer_4585625" {
  name                   = "4585625.json"
  storage_account_name   = azurerm_storage_account.conf.name
  storage_container_name = azurerm_storage_container.acquirer_conf.name
  type                   = "Block"
  source                 = "templates/4585625.json"
}

resource "azurerm_storage_blob" "acquirer_4585626" {
  name                   = "4585626.json"
  storage_account_name   = azurerm_storage_account.conf.name
  storage_container_name = azurerm_storage_container.acquirer_conf.name
  type                   = "Block"
  source                 = "templates/4585625.json"
}