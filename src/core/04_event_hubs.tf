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
  public_network_access_enabled = true
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