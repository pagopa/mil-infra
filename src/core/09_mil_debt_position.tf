# ==============================================================================
# This file contains stuff needed to run mil-debt-position microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_debt_position_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_debt_position_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_debt_position_json_log" {
  type    = bool
  default = true
}

variable "mil_debt_position_quarkus_rest_client_logging_scope" {
  description = "Scope for Quarkus REST client logging. Allowed values are: all, request-response, none."
  type        = string
  default     = "all"
}

variable "mil_debt_position_openapi_descriptor" {
  type = string
}

variable "mil_debt_position_image" {
  type = string
}

variable "mil_debt_position_cpu" {
  type    = number
  default = 1
}

variable "mil_debt_position_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_debt_position_max_replicas" {
  type    = number
  default = 10
}

variable "mil_debt_position_min_replicas" {
  type    = number
  default = 1
}

variable "mil_debt_position_path" {
  type    = string
  default = "mil-debt-position"
}

variable "mil_debt_position_backoff_num_of_attempts" {
  type    = number
  default = 3
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "debt_position" {
  name                         = "${local.project}-debt-position-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Single"

  template {
    container {
      name   = "mil-debt-position"
      image  = var.mil_debt_position_image
      cpu    = var.mil_debt_position_cpu
      memory = var.mil_debt_position_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "debt-position.quarkus-log-level"
        value = var.mil_debt_position_quarkus_log_level
      }

      env {
        name  = "debt-position.quarkus-rest-client-logging-scope"
        value = var.mil_debt_position_quarkus_rest_client_logging_scope
      }

      env {
        name  = "debt-position.app-log-level"
        value = var.mil_debt_position_app_log_level
      }

      env {
        name  = "debt-position.base-url"
        value = "${azurerm_api_management.mil.gateway_url}/${var.mil_debt_position_path}"
      }

      env {
        name  = "application-insights.connection-string"
        value = azurerm_application_insights.mil.connection_string
      }

      env {
        name  = "debt_position.json-log"
        value = var.mil_debt_position_json_log
      }

      env {
        name  = "debt_position.keyvault.backoff.number-of-attempts"
        value = var.mil_debt_position_backoff_num_of_attempts
      }

      env {
        name  = "jwt-publickey-location"
        value = "http://127.0.0.1:8080/.well-known/jwks.json"
      }
    }

    max_replicas = var.mil_debt_position_max_replicas
    min_replicas = var.mil_debt_position_min_replicas
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
resource "azurerm_log_analytics_query_pack_query" "debt_position_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-debt-position' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\\\[(.*?)\\\\]', 1, Log_s) | extend log_level = extract('\\\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-debt-position - last hour logs ***"
}

resource "azurerm_log_analytics_query_pack_query" "debt_position_ca_json_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL\n| where ContainerName_s == 'mil-debt-position'\n| where time_t > ago(60m)\n| sort by time_t asc\n| extend ParsedJSON = parse_json(Log_s)\n| project \n    app_timestamp=ParsedJSON.timestamp,\n    app_sequence=ParsedJSON.sequence,\n    app_loggerClassName=ParsedJSON.loggerClassName,\n    app_loggerName=ParsedJSON.loggerName,\n    app_level=ParsedJSON.level,\n    app_message=ParsedJSON.message,\n    app_threadName=ParsedJSON.threadName,\n    app_threadId=ParsedJSON.threadId,\n    app_mdc=ParsedJSON.mdc,\n    app_requestId=ParsedJSON.mdc.requestId,\n    app_ndc=ParsedJSON.ndc,\n    app_hostName=ParsedJSON.hostName,\n    app_processId=ParsedJSON.processId"
  display_name  = "*** mil-debt-position - last hour json logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "debt_position" {
  name                  = "${local.project}-debt-position"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "debt-position"
  description           = "Debt Position Microservice for Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_debt_position_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.debt_position.ingress[0].fqdn}"
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_debt_position_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "debt_position" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.debt_position.name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "debt_position" {
  identifier                = "applicationinsights"
  resource_group_name       = azurerm_api_management.mil.resource_group_name
  api_management_name       = azurerm_api_management.mil.name
  api_name                  = azurerm_api_management_api.debt_position.name
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
