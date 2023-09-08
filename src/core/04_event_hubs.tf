#
# Event hub namespace
#
resource "azurerm_eventhub_namespace" "mil_evhns" {
  name                          = "${local.project}-evhns"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  sku                           = "Standard"
  capacity                      = 1
  local_authentication_enabled  = true
  zone_redundant                = true
  public_network_access_enabled = var.env_short == "d" ? true : false
  auto_inflate_enabled          = false
  tags                          = var.tags
}

#
# Event hub used by mil-payment-notice -> mil-preset
#
resource "azurerm_eventhub" "presets" {
  name                = "${local.project}-presets-evh"
  namespace_name      = azurerm_eventhub_namespace.mil_evhns.name
  resource_group_name = azurerm_eventhub_namespace.mil_evhns.resource_group_name
  partition_count     = 1
  message_retention   = 7
}

#
# PRIVATE ENDPOINT APP SUBNET -> EVENT HUB
#
resource "azurerm_private_dns_zone" "eventhub" {
  count               = var.env_short == "d" ? 0 : 1
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventhub" {
  count                 = var.env_short == "d" ? 0 : 1
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.eventhub[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "eventhub_pep" {
  count               = var.env_short == "d" ? 0 : 1
  name                = "${local.project}-eventhub-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-eventhub-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-eventhub-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.eventhub[0].id]
  }

  private_service_connection {
    name                           = "${local.project}-eventhub-psc"
    private_connection_resource_id = azurerm_eventhub_namespace.mil_evhns.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}