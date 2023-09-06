#
# Account
#
resource "azurerm_cosmosdb_account" "mil" {
  name                          = "${local.project}-cosmos"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  kind                          = "MongoDB"
  offer_type                    = "Standard"
  tags                          = var.tags
  public_network_access_enabled = var.env_short == "p" ? false : true

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

#
# Database
#
resource "azurerm_cosmosdb_mongo_database" "mil" {
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}

# Collection for services
#resource "azurerm_cosmosdb_mongo_collection" "services" {
#  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
#  database_name       = azurerm_cosmosdb_mongo_database.mil.name
#  name                = "services"
#  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name
#
#  index {
#    keys   = ["_id"]
#    unique = true
#  }
#
#  index {
#    keys   = ["channel"]
#    unique = true
#  }
#}

#
# Collection for mil-payment-notice
#
resource "azurerm_cosmosdb_mongo_collection" "paymentTransactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "paymentTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "terminalId",
      "merchantId",
      "channel",
      "acquirerId",
      "insertTimestamp"
    ]
    unique = false
  }
}

#
# Collections for mil-preset
#
resource "azurerm_cosmosdb_mongo_collection" "presets" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "presets"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "presetOperation.paTaxCode",
      "presetOperation.subscriberId",
      "presetOperation.status",
      "presetOperation.creationTimestamp"
    ]
    unique = false
  }
}

resource "azurerm_cosmosdb_mongo_collection" "subscribers" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "subscribers"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "subscriber.acquirerId",
      "subscriber.channel",
      "subscriber.merchantId",
      "subscriber.terminalId",
      "subscriber.paTaxCode"
    ]
    unique = false
  }

  index {
    keys = [
      "subscriber.paTaxCode",
      "subscriber.subscriberId"
    ]
    unique = false
  }
}

#
# Collection for mil-idpay
#
resource "azurerm_cosmosdb_mongo_collection" "idpayTransactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "idpayTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "transactionId"
    ]
    unique = false
  }
}

#
# PRIVATE ENDPOINT APP SUBNET -> COSMOS
#
resource "azurerm_private_dns_zone" "cosmos" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  count                 = var.env_short == "p" ? 1 : 0
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "cosmos_pep" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "${local.project}-cosmos-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-cosmos-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos[0].id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mil.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }
}