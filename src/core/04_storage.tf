# ==============================================================================
# This file contains stuff needed to setup the storage account that contains
# acquirers configuration. It is used by mil-payment-notice and
# mil-fee-calculator microservices.
# ==============================================================================

# ------------------------------------------------------------------------------
# Storage account.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "conf" {
  name                          = "${var.prefix}${var.env_short}confst"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Storage container.
# ------------------------------------------------------------------------------
#resource "azurerm_storage_container" "acquirers" {
#  name                  = "acquirers"
#  storage_account_name  = azurerm_storage_account.conf.name
#  container_access_type = var.armored_storage_account_for_acquirers_conf ? "private" : "blob"
#}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to the storage
# account.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "conf_storage_pep" {
  name                = "${local.project}-conf-storage-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-conf-storage-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-conf-storage-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-conf-storage-psc"
    private_connection_resource_id = azurerm_storage_account.conf.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}