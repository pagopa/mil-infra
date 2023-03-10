resource "azurerm_storage_account" "conf" {
  name                     = "milconf"
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

#
# PRIVATE ENDPOINT APIM SUBNET -> STORAGE
#
#resource "azurerm_private_dns_zone" "storage" {
#  name                = "privatelink.blob.core.windows.net"
#  resource_group_name = azurerm_resource_group.network.name
#}
#
#resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
#  name                  = azurerm_virtual_network.integr.name
#  resource_group_name   = azurerm_resource_group.network.name
#  private_dns_zone_name = azurerm_private_dns_zone.storage.name
#  virtual_network_id    = azurerm_virtual_network.integr.id
#}
#
#resource "azurerm_private_endpoint" "storage_pep" {
#  name                = "${local.project}-storage-pep"
#  location            = azurerm_resource_group.network.location
#  resource_group_name = azurerm_resource_group.network.name
#  subnet_id           = azurerm_subnet.apim.id
#
#  custom_network_interface_name = "${local.project}-storage-pep-nic"
#
#  private_dns_zone_group {
#    name                 = "${local.project}-storage-pdzg"
#    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
#  }
#
#  private_service_connection {
#    name                           = "${local.project}-storage-psc"
#    private_connection_resource_id = azurerm_storage_account.conf.id
#    subresource_names              = ["blob"]
#    is_manual_connection           = false
#  }
#}