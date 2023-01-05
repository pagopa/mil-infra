# Account
resource "azurerm_cosmosdb_account" "mil" {
  name                = "${local.project}-cosmos"
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location
  kind                = "MongoDB"
  offer_type          = "Standard"
  tags                = var.tags

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    failover_priority = 0
    location          = "westeurope"
  }
}

# Database
resource "azurerm_cosmosdb_mongo_database" "mil" {
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "mil"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}

# Collection for services
resource "azurerm_cosmosdb_mongo_collection" "services" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "services"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["channel"]
    unique = true
  }
}
