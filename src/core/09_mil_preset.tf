# ==============================================================================
# This file contains stuff needed to run mil-preset microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_preset_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_preset_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_preset_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_preset_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_preset_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_preset_image" {
  type = string
}

variable "mil_preset_cpu" {
  type    = number
  default = 1
}

variable "mil_preset_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_preset_max_replicas" {
  type    = number
  default = 10
}

variable "mil_preset_min_replicas" {
  type    = number
  default = 1
}

variable "mil_preset_openapi_descriptor" {
  type = string
}

variable "mil_preset_path" {
  type    = string
  default = "mil-preset"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collections.
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mil_preset" {
  name                         = "${local.project}-preset-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mil-preset"
      image  = var.mil_preset_image
      cpu    = var.mil_preset_cpu
      memory = var.mil_preset_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "preset.quarkus-log-level"
        value = var.mil_preset_quarkus_log_level
      }

      env {
        name  = "preset.app-log-level"
        value = var.mil_preset_app_log_level
      }

      env {
        name  = "mongo-connect-timeout"
        value = var.mil_preset_mongo_connect_timeout
      }

      env {
        name  = "mongo-read-timeout"
        value = var.mil_preset_mongo_read_timeout
      }

      env {
        name  = "mongo-server-selection-timeout"
        value = var.mil_preset_mongo_server_selection_timeout
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
        name  = "preset.location.base-url"
        value = "${module.apim.gateway_url}/${var.mil_preset_path}"
      }

      env {
        name        = "kafka-connection-string-1"
        secret_name = "kafka-connection-string-1"
      }

      env {
        name        = "kafka-connection-string-2"
        secret_name = "kafka-connection-string-2"
      }

      env {
        name  = "kafka-bootstrap-server"
        value = local.kafka_bootstrap_server
      }

      env {
        name  = "kafka-topic"
        value = azurerm_eventhub.presets.name
      }

      env {
        name  = "jwt-publickey-location"
        value = "${module.apim.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
      }
    }

    max_replicas = var.mil_preset_max_replicas
    min_replicas = var.mil_preset_min_replicas
  }

  secret {
    name  = "mongo-connection-string-1"
    value = azurerm_cosmosdb_account.mil.connection_strings[0]
  }

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.connection_strings[1]
  }

  secret {
    name  = "kafka-connection-string-1"
    value = azurerm_eventhub_namespace.mil_evhns.default_primary_connection_string
  }

  secret {
    name  = "kafka-connection-string-2"
    value = azurerm_eventhub_namespace.mil_evhns.default_secondary_connection_string
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
resource "azurerm_log_analytics_query_pack_query" "mil_preset_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-preset' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-preset - last hour logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
module "preset_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-preset"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Preset Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_preset.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = var.mil_preset_path

  display_name          = "preset"
  content_format        = "openapi-link"
  content_value         = var.mil_preset_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "preset_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.preset_api.name
  api_management_logger_id = module.apim.logger_id

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
