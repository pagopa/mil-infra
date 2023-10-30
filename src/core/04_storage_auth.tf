#
# Storage account used by mil-auth
#
resource "azurerm_storage_account" "auth" {
  name                          = "${var.prefix}${var.env_short}authst"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}

#
# Storage container for clients configuration
#
resource "azurerm_storage_container" "clients" {
  name                  = "clients"
  storage_account_name  = azurerm_storage_account.auth.name
  container_access_type = "private"
}

#
# Storage container for roles configuration
#
resource "azurerm_storage_container" "roles" {
  name                  = "roles"
  storage_account_name  = azurerm_storage_account.auth.name
  container_access_type = "private"
}

#
# Storage container for users configuration (this is a temporary solution)
#
resource "azurerm_storage_container" "users" {
  name                  = "users"
  storage_account_name  = azurerm_storage_account.auth.name
  container_access_type = "private"
}

#
# PRIVATE ENDPOINT APP SUBNET -> THIS STORAGE ACCOUNT
#
resource "azurerm_private_dns_zone" "auth_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "auth_storage" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.auth_storage.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "auth_storage_pep" {
  name                = "${local.project}-auth-storage-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-auth-storage-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-auth-storage-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.auth_storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-auth-storage-psc"
    private_connection_resource_id = azurerm_storage_account.auth.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}