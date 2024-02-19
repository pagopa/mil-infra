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


# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "terminal_registry" {
  name                         = "${local.project}-terminal-registry-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

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
        name  = "quarkus-log-level"
        value = var.mil_terminal_registry_quarkus_log_level
      }

      env {
        name  = "app-log-level"
        value = var.mil_terminal_registry_app_log_level
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
    value = azurerm_cosmosdb_account.mil.connection_strings[0]
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
