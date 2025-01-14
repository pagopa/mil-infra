# ==============================================================================
# This file contains stuff needed to run mil-auth microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_auth_openapi_descriptor" {
  type = string
}

variable "mil_auth_path" {
  type    = string
  default = "mil-auth"
}

# ------------------------------------------------------------------------------
# Storage account containing configuration files.
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to the storage
# account.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "auth_storage" {
  name                = "${local.project}-auth-storage-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-auth-storage-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-auth-storage-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-auth-storage-psc"
    private_connection_resource_id = azurerm_storage_account.auth.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

# ------------------------------------------------------------------------------
# Storing storage account blob endpoint in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "storage_account_auth_primary_blob_endpoint" {
  name         = "storage-account-auth-primary-blob-endpoint"
  value        = azurerm_storage_account.auth.primary_blob_endpoint
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "clients" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "clients"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "clientId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "roles" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "roles"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["id"]
    unique = true
  }

  index {
    keys = [
      "clientId",
      "acquirerId",
      "channel",
      "merchantId",
      "terminalId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# Key vault for cryptographics operations.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "auth" {
  name                          = "${local.project}-auth-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  sku_name                      = "premium"
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to the key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "auth_key_vault" {
  name                = "${local.project}-auth-kv-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-auth-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-auth-kv-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-auth-kv-psc"
    private_connection_resource_id = azurerm_key_vault.auth.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

# ------------------------------------------------------------------------------
# Storing auth key vault URL in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "key_vault_auth_vault_uri" {
  name         = "key-vault-auth-vault-uri"
  value        = azurerm_key_vault.auth.vault_uri
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# Identity for container app.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "auth" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${var.prefix}-${var.env_short}-auth-identity"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Crypto Officer" to user-managed identity of
# container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv_for_auth_identity" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Certificates Officer" to user-managed
# identity of container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv_to_read_certificates_for_auth_identity" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Secrets Officer" to user-managed identity of
# container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv_to_read_secrets_for_auth_identity" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

resource "azurerm_role_assignment" "general_kv_to_read_secrets_for_auth_identity" {
  scope                = azurerm_key_vault.general.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Storage Blob Data Reader" to system-managed identity of
# container app, to use storage account.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_storage_for_auth_identity" {
  scope                = azurerm_storage_account.auth.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.auth.principal_id
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "auth_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-auth' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\\\[(.*?)\\\\]', 1, Log_s) | extend log_level = extract('\\\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-auth - last hour logs ***"
}

resource "azurerm_log_analytics_query_pack_query" "auth_ca_json_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL\n| where ContainerName_s == 'mil-auth'\n| where time_t > ago(60m)\n| sort by time_t asc\n| extend ParsedJSON = parse_json(Log_s)\n| project \n    app_timestamp=ParsedJSON.timestamp,\n    app_sequence=ParsedJSON.sequence,\n    app_loggerClassName=ParsedJSON.loggerClassName,\n    app_loggerName=ParsedJSON.loggerName,\n    app_level=ParsedJSON.level,\n    app_message=ParsedJSON.message,\n    app_threadName=ParsedJSON.threadName,\n    app_threadId=ParsedJSON.threadId,\n    app_mdc=ParsedJSON.mdc,\n    app_requestId=ParsedJSON.mdc.requestId,\n    app_ndc=ParsedJSON.ndc,\n    app_hostName=ParsedJSON.hostName,\n    app_processId=ParsedJSON.processId"
  display_name  = "*** mil-auth - last hour json logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "auth" {
  name                = "${local.project}-auth"
  resource_group_name = azurerm_api_management.mil.resource_group_name
  api_management_name = azurerm_api_management.mil.name
  revision            = "1"
  display_name        = "auth"
  description         = "Authorization Microservice for Multi-channel Integration Layer of SW Client Project"
  path                = var.mil_auth_path
  protocols           = ["https"]
  service_url         = "https://${local.project}-auth-ca.${azurerm_private_dns_zone.mil_cae.name}"

  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_auth_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "auth" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "auth" {
  identifier                = "applicationinsights"
  resource_group_name       = azurerm_api_management.mil.resource_group_name
  api_management_name       = azurerm_api_management.mil.name
  api_name                  = azurerm_api_management_api.auth.name
  api_management_logger_id  = azurerm_api_management_logger.mil.id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  frontend_response {
    body_bytes = 8192
    headers_to_log = [
      "CorrelationId",
      "Cache-Control"
    ]
  }

  backend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  backend_response {
    body_bytes = 8192
    headers_to_log = [
      "CorrelationId",
      "Cache-Control"
    ]
  }
}
