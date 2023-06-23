#
# Storage account
#
resource "azurerm_storage_account" "conf" {
  name                     = "${var.prefix}${var.env_short}confst"
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  #public_network_access_enabled = false
  tags                     = var.tags

  network_rules {
    default_action = "Deny"
    bypass         = ["Metrics", "Logging", "AzureServices"]
  }
}

#
# Storage container for acquirer conf used by mil-acquirer-conf
#
resource "azurerm_storage_container" "acquirers" {
  name                  = "acquirers"
  storage_account_name  = azurerm_storage_account.conf.name
  container_access_type = "blob"
}

#
# Storage container for clients conf used by mil-auth
#
resource "azurerm_storage_container" "clients" {
  name                  = "clients"
  storage_account_name  = azurerm_storage_account.conf.name
  container_access_type = "blob"
}

#
# Storage container for roles conf used by mil-auth
#
resource "azurerm_storage_container" "roles" {
  name                  = "roles"
  storage_account_name  = azurerm_storage_account.conf.name
  container_access_type = "blob"
}

#
# Storage container for users conf used by mil-auth (this is a temporary solution)
#
resource "azurerm_storage_container" "users" {
  name                  = "users"
  storage_account_name  = azurerm_storage_account.conf.name
  container_access_type = "blob"
}

#
# PRIVATE ENDPOINT APP SUBNET -> STORAGE ACCOUNT
#
resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "storage_pep" {
  name                = "${local.project}-storage-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-storage-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-storage-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-storage-psc"
    private_connection_resource_id = azurerm_storage_account.conf.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}