# ==============================================================================
# This file contains stuff needed to run mil-papos microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_papos_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_papos_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_papos_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_papos_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_papos_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_papos_image" {
  type = string
}

variable "mil_papos_cpu" {
  type    = number
  default = 1
}

variable "mil_papos_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_papos_max_replicas" {
  type    = number
  default = 10
}

variable "mil_papos_min_replicas" {
  type    = number
  default = 1
}

variable "mil_papos_openapi_descriptor" {
  type = string
}

variable "mil_papos_path" {
  type    = string
  default = "mil-papos"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collections.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "terminals" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "terminals"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  #index {
  #  keys = [
  #    "...",
  #    "...",
  #    "...",
  #    "..."
  #  ]
  #  unique = false
  #}
}

resource "azurerm_cosmosdb_mongo_collection" "transactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "transactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_cosmosdb_mongo_collection" "bulkLoadStatuses" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "bulkLoadStatuses"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "papos" {
  name                         = "${local.project}-papos-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Single"

  template {
    container {
      name   = "mil-papos"
      image  = var.mil_papos_image
      cpu    = var.mil_papos_cpu
      memory = var.mil_papos_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "quarkus-log-level"
        value = var.mil_papos_quarkus_log_level
      }

      env {
        name  = "app-log-level"
        value = var.mil_papos_app_log_level
      }

      env {
        name  = "mongo-connect-timeout"
        value = var.mil_papos_mongo_connect_timeout
      }

      env {
        name  = "mongo-read-timeout"
        value = var.mil_papos_mongo_read_timeout
      }

      env {
        name  = "mongo-server-selection-timeout"
        value = var.mil_papos_mongo_server_selection_timeout
      }

      env {
        name        = "mongo-connection-string-1"
        secret_name = "mongo-connection-string-1"
      }

      env {
        name        = "mongo-connection-string-2"
        secret_name = "mongo-connection-string-2"
      }

      env {
        name  = "papos.location.base-url"
        value = "${azurerm_api_management.mil.gateway_url}/${var.mil_papos_path}"
      }

      env {
        name = "jwt-publickey-location"
        #value = "${azurerm_api_management.mil.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
        #value = "https://${azurerm_container_app.auth.ingress[0].fqdn}/.well-known/jwks.json"
        value = "https://${local.project}-auth-ca.${azurerm_private_dns_zone.mil_cae.name}/.well-known/jwks.json"
      }

      env {
        name  = "application-insights.connection-string"
        value = azurerm_application_insights.mil.connection_string
      }
    }

    max_replicas = var.mil_papos_max_replicas
    min_replicas = var.mil_papos_min_replicas
  }

  secret {
    name  = "mongo-connection-string-1"
    value = azurerm_cosmosdb_account.mil.primary_mongodb_connection_string
  }

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.secondary_mongodb_connection_string
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
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "mil_papos_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-papos' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\\\[(.*?)\\\\]', 1, Log_s) | extend log_level = extract('\\\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-papos - last hour logs ***"
}

resource "azurerm_log_analytics_query_pack_query" "mil_papos_ca_json_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL\n| where ContainerName_s == 'mil-papos'\n| where time_t > ago(60m)\n| sort by time_t asc\n| extend ParsedJSON = parse_json(Log_s)\n| project \n    app_timestamp=ParsedJSON.timestamp,\n    app_sequence=ParsedJSON.sequence,\n    app_loggerClassName=ParsedJSON.loggerClassName,\n    app_loggerName=ParsedJSON.loggerName,\n    app_level=ParsedJSON.level,\n    app_message=ParsedJSON.message,\n    app_threadName=ParsedJSON.threadName,\n    app_threadId=ParsedJSON.threadId,\n    app_mdc=ParsedJSON.mdc,\n    app_requestId=ParsedJSON.mdc.requestId,\n    app_ndc=ParsedJSON.ndc,\n    app_hostName=ParsedJSON.hostName,\n    app_processId=ParsedJSON.processId"
  display_name  = "*** mil-papos - last hour json logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "papos" {
  name                  = "${local.project}-papos"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "papos"
  description           = "PA POS Microservice for Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_papos_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.papos.ingress[0].fqdn}"
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_papos_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "papos" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.papos.name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "papos" {
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_api_management.mil.resource_group_name
  api_management_name      = azurerm_api_management.mil.name
  api_name                 = azurerm_api_management_api.papos.name
  api_management_logger_id = azurerm_api_management_logger.mil.id

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
      "Location"
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
      "Location"
    ]
  }
}
