# ==============================================================================
# This file contains stuff needed to run mil-auth microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_auth_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_auth_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_auth_json_log" {
  type    = bool
  default = true
}

variable "mil_auth_quarkus_rest_client_logging_scope" {
  description = "Scope for Quarkus REST client logging. Allowed values are: all, request-response, none."
  type        = string
  default     = "all"
}

variable "mil_auth_cryptoperiod" {
  type    = number
  default = 86400000
}

variable "mil_auth_keysize" {
  type    = number
  default = 4096
}

variable "mil_auth_access_duration" {
  type    = number
  default = 900
}

variable "mil_auth_refresh_duration" {
  type    = number
  default = 3600
}

variable "mil_auth_openapi_descriptor" {
  type = string
}

variable "mil_auth_image" {
  type = string
}

variable "mil_auth_cpu" {
  type    = number
  default = 1
}

variable "mil_auth_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_auth_max_replicas" {
  type    = number
  default = 10
}

variable "mil_auth_min_replicas" {
  type    = number
  default = 1
}

variable "mil_auth_path" {
  type    = string
  default = "mil-auth"
}

variable "mil_auth_keyvault_maxresults" {
  type    = number
  default = 20
}

variable "mil_auth_keyvault_backoff_num_of_attempts" {
  type    = number
  default = 3
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
# Storage container containing files to configure clients.
# ------------------------------------------------------------------------------
#resource "azurerm_storage_container" "clients" {
#  name                  = "clients"
#  storage_account_name  = azurerm_storage_account.auth.name
#  container_access_type = var.mil_auth_armored_storage_account ? "private" : "blob"
#}

# ------------------------------------------------------------------------------
# Storage container containing files to configure roles.
# ------------------------------------------------------------------------------
#resource "azurerm_storage_container" "roles" {
#  name                  = "roles"
#  storage_account_name  = azurerm_storage_account.auth.name
#  container_access_type = var.mil_auth_armored_storage_account ? "private" : "blob"
#}

# ------------------------------------------------------------------------------
# Storage container containing files to configure users (this is a temporary
# solution).
# ------------------------------------------------------------------------------
#resource "azurerm_storage_container" "users" {
#  name                  = "users"
#  storage_account_name  = azurerm_storage_account.auth.name
#  container_access_type = var.mil_auth_armored_storage_account ? "private" : "blob"
#}

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
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "auth" {
  name                         = "${local.project}-auth-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Single"

  template {
    container {
      name   = "mil-auth"
      image  = var.mil_auth_image
      cpu    = var.mil_auth_cpu
      memory = var.mil_auth_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "auth.quarkus-log-level"
        value = var.mil_auth_quarkus_log_level
      }

      env {
        name  = "auth.quarkus-rest-client-logging-scope"
        value = var.mil_auth_quarkus_rest_client_logging_scope
      }

      env {
        name  = "auth.app-log-level"
        value = var.mil_auth_app_log_level
      }

      env {
        name  = "auth.cryptoperiod"
        value = var.mil_auth_cryptoperiod
      }

      env {
        name  = "auth.keysize"
        value = var.mil_auth_keysize
      }

      env {
        name  = "auth.access.duration"
        value = var.mil_auth_access_duration
      }

      env {
        name  = "auth.refresh.duration"
        value = var.mil_auth_refresh_duration
      }

      env {
        name  = "auth.data.url"
        value = azurerm_storage_account.auth.primary_blob_endpoint
      }

      env {
        name  = "auth.keyvault.url"
        value = azurerm_key_vault.auth.vault_uri
      }

      env {
        name  = "auth.base-url"
        value = "${azurerm_api_management.mil.gateway_url}/${var.mil_auth_path}"
      }
      
      env {
        name  = "application-insights.connection-string"
        value = azurerm_application_insights.mil.connection_string
      }

      env {
        name  = "auth.json-log"
        value = var.mil_auth_json_log
      }
      
      env {
        name  = "auth.keyvault.maxresults"
        value = var.mil_auth_keyvault_maxresults
      }

      env {
        name  = "auth.keyvault.backoff.number-of-attempts"
        value = var.mil_auth_keyvault_backoff_num_of_attempts
      }

      env {
        name  = "jwt-publickey-location"
        value = "http://127.0.0.1:8080/.well-known/jwks.json"
      }
    }

    max_replicas = var.mil_auth_max_replicas
    min_replicas = var.mil_auth_min_replicas
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = formatdate("YYYYMMDDhhmmssZZZZ", timestamp())
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Crypto Officer" to system-managed identity of
# container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_container_app.auth.identity[0].principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Certificates Officer" to system-managed
# identity of container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv_to_read_certificates" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_container_app.auth.identity[0].principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Secrets Officer" to system-managed identity of
# container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_kv_to_read_secrets" {
  scope                = azurerm_key_vault.auth.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_container_app.auth.identity[0].principal_id
}

# ------------------------------------------------------------------------------
# Assignement of role "Storage Blob Data Reader" to system-managed identity of
# container app, to use storage account.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "auth_storage" {
  scope                = azurerm_storage_account.auth.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_container_app.auth.identity[0].principal_id
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
  name                  = "${local.project}-auth"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "auth"
  description           = "Authorization Microservice for Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_auth_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.auth.ingress[0].fqdn}"
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
