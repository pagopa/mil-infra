# ==============================================================================
# This file contains stuff needed to run mil-terminal-registry microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_terminal_registry_image" {
  type = string
}

variable "mil_terminal_registry_cpu" {
  type    = number
  default = 1
}

variable "mil_terminal_registry_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_terminal_registry_max_replicas" {
  type    = number
  default = 10
}

variable "mil_terminal_registry_min_replicas" {
  type    = number
  default = 1
}

variable "mil_terminal_registry_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_terminal_registry_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_terminal_registry_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_terminal_registry_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_terminal_registry_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_terminal_registry_path" {
  type    = string
  default = "mil-terminal-registry"
}

variable "mil_terminal_registry_openapi_descriptor" {
  type = string
}


# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "terminal_registry" {
  name                         = "${local.project}-terminal-registry-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Single"

  template {
    container {
      name   = "mil-terminal-registry"
      image  = var.mil_terminal_registry_image
      cpu    = var.mil_terminal_registry_cpu
      memory = var.mil_terminal_registry_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name        = "mongo.connection-string-1"
        secret_name = "mongo-connection-string-1"
      }

      env {
        name        = "mongo.connection-string-2"
        secret_name = "mongo-connection-string-2"
      }

      env {
        name  = "quarkus-log-level"
        value = var.mil_terminal_registry_quarkus_log_level
      }

      env {
        name  = "app-log-level"
        value = var.mil_terminal_registry_app_log_level
      }

      env {
        name  = "mongo.connect-timeout"
        value = var.mil_terminal_registry_mongo_connect_timeout
      }

      env {
        name  = "mongo.read-timeout"
        value = var.mil_terminal_registry_mongo_read_timeout
      }

      env {
        name  = "mongo.server-selection-timeout"
        value = var.mil_terminal_registry_mongo_server_selection_timeout
      }

      env {
        name = "jwt-publickey-location"
        #value = "${azurerm_api_management.mil.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
        value = "https://${azurerm_container_app.auth.ingress[0].fqdn}/.well-known/jwks.json"
      }

      env {
        name  = "application-insights.connection-string"
        value = azurerm_application_insights.mil.connection_string
      }
    }

    max_replicas = var.mil_terminal_registry_max_replicas
    min_replicas = var.mil_terminal_registry_min_replicas
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

  secret {
    name  = "mongo-connection-string-1"
    value = azurerm_cosmosdb_account.mil.primary_mongodb_connection_string
  }

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.secondary_mongodb_connection_string
  }


  tags = var.tags
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "mil_terminal_registry_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-terminal-registry' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\\\[(.*?)\\\\]', 1, Log_s) | extend log_level = extract('\\\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-terminal_registry - last hour logs ***"
}

resource "azurerm_log_analytics_query_pack_query" "mil_terminal_registry_ca_json_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL\n| where ContainerName_s == 'mil-terminal-registry'\n| where time_t > ago(60m)\n| sort by time_t asc\n| extend ParsedJSON = parse_json(Log_s)\n| project \n    app_timestamp=ParsedJSON.timestamp,\n    app_sequence=ParsedJSON.sequence,\n    app_loggerClassName=ParsedJSON.loggerClassName,\n    app_loggerName=ParsedJSON.loggerName,\n    app_level=ParsedJSON.level,\n    app_message=ParsedJSON.message,\n    app_threadName=ParsedJSON.threadName,\n    app_threadId=ParsedJSON.threadId,\n    app_mdc=ParsedJSON.mdc,\n    app_requestId=ParsedJSON.mdc.requestId,\n    app_ndc=ParsedJSON.ndc,\n    app_hostName=ParsedJSON.hostName,\n    app_processId=ParsedJSON.processId"
  display_name  = "*** mil-terminal-registry - last hour json logs ***"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "terminal_registry" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "terminal_registry"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "terminal_registry" {
  name                  = "${local.project}-terminal-registry"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "terminal-registry"
  description           = "IDPay Microservice for managing terminals anagraphics on Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_terminal_registry_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.terminal_registry.ingress[0].fqdn}"
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_terminal_registry_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "terminal_registry" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.terminal_registry.name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}
