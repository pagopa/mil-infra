
# ==============================================================================
# This file contains stuff needed to setup event hub used by mil-payment-notice
# and mil-preset microservices.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "armored_event_hub" {
  description = "If true the event hub will be protected with private link."
  type        = bool
}

# ------------------------------------------------------------------------------
# Event hub namespace.
# ------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "mil_evhns" {
  name                          = "${local.project}-evhns"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  sku                           = "Standard"
  capacity                      = 1
  local_authentication_enabled  = true
  zone_redundant                = true
  public_network_access_enabled = var.armored_event_hub ? false : true
  auto_inflate_enabled          = false
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Event hub.
# ------------------------------------------------------------------------------
resource "azurerm_eventhub" "presets" {
  name                = "${local.project}-presets-evh"
  namespace_name      = azurerm_eventhub_namespace.mil_evhns.name
  resource_group_name = azurerm_eventhub_namespace.mil_evhns.resource_group_name
  partition_count     = 1
  message_retention   = 7
}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to the event hub.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "eventhub" {
  count               = var.armored_event_hub ? 1 : 0
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventhub" {
  count                 = var.armored_event_hub ? 1 : 0
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.eventhub[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "eventhub_pep" {
  count               = var.armored_event_hub ? 1 : 0
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

# ------------------------------------------------------------------------------
# Definition of a local variable containing the Kafka boostrap server.
# ------------------------------------------------------------------------------
locals {
  kafka_bootstrap_server = "${azurerm_eventhub_namespace.mil_evhns.name}.servicebus.windows.net:9093"
}