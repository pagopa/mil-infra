# ==============================================================================
# This file contains stuff needed to setup CosmosDB.
# ==============================================================================

# ------------------------------------------------------------------------------
# CosmosDB account.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_account" "mil" {
  name                          = "${local.project}-cosmos"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  kind                          = "MongoDB"
  offer_type                    = "Standard"
  tags                          = var.tags
  public_network_access_enabled = false

  capabilities {
    name = "EnableUniqueCompoundNestedDocs"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mil" {
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to CosmosDB.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "${local.project}-cosmos-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-cosmos-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mil.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }
}