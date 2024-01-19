# ==============================================================================
# This file contains stuff needed to run mil-payment-notice microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_payment_notice_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "nodo_soap_url" {
  description = "URL of the SOAP endpoint (verify and activate operations) of the real Nodo."
  type        = string
}

variable "nodo_rest_url" {
  description = "URL of the REST endpoint (close payment) of the real Nodo."
  type        = string
}

variable "mil_payment_notice_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_payment_notice_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_payment_notice_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_payment_notice_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_payment_notice_node_soap_client_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_node_soap_client_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_rest_client_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_rest_client_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_closepayment_max_retry" {
  type    = number
  default = 3
}

variable "mil_payment_notice_closepayment_retry_after" {
  type    = number
  default = 30
}

variable "mil_payment_notice_activatepayment_expiration_time" {
  type    = number
  default = 30000
}

variable "mil_payment_notice_image" {
  type = string
}

variable "mil_payment_notice_cpu" {
  type    = number
  default = 1
}

variable "mil_payment_notice_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_payment_notice_max_replicas" {
  type    = number
  default = 10
}

variable "mil_payment_notice_min_replicas" {
  type    = number
  default = 1
}

variable "mil_payment_notice_openapi_descriptor" {
  type = string
}

variable "mil_payment_notice_path" {
  type    = string
  default = "mil-payment-notice"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection.
# ------------------------------------------------------------------------------
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
      "paymentTransaction.terminalId",
      "paymentTransaction.merchantId",
      "paymentTransaction.channel",
      "paymentTransaction.acquirerId",
      "paymentTransaction.insertTimestamp"
    ]
    unique = false
  }

  index {
    keys = [
      "paymentTransaction.insertTimestamp"
    ]
    unique = false
  }
}

# ------------------------------------------------------------------------------
# Redis cache.
# ------------------------------------------------------------------------------
resource "azurerm_redis_cache" "mil" {
  name                          = "${local.project}-redis"
  location                      = azurerm_resource_group.data.location
  resource_group_name           = azurerm_resource_group.data.name
  capacity                      = 1
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  family                        = "C"
  sku_name                      = "Basic"
  public_network_access_enabled = false
  redis_version                 = 6
  tags                          = var.tags

  redis_configuration {
    enable_authentication = true
  }
}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to Redis.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "redis" {
  name                = "${local.project}-redis-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-redis-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-redis-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }

  private_service_connection {
    name                           = "${local.project}-redis-psc"
    private_connection_resource_id = azurerm_redis_cache.mil.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }
}

# ------------------------------------------------------------------------------
# Get API key for SOAP endpoint of Nodo from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "node_soap_subscription_key" {
  name         = "node-soap-subscription-key"
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# Get API key for REST endpoint of Nodo from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "node_rest_subscription_key" {
  name         = "node-rest-subscription-key"
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "payment_notice" {
  name                         = "${local.project}-payment-notice-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mil-payment-notice"
      image  = var.mil_payment_notice_image
      cpu    = var.mil_payment_notice_cpu
      memory = var.mil_payment_notice_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "paymentnotice.quarkus-log-level"
        value = var.mil_payment_notice_quarkus_log_level
      }

      env {
        name  = "paymentnotice.app-log-level"
        value = var.mil_payment_notice_app_log_level
      }

      env {
        name  = "mongo-connect-timeout"
        value = var.mil_payment_notice_mongo_connect_timeout
      }

      env {
        name  = "mongo-read-timeout"
        value = var.mil_payment_notice_mongo_read_timeout
      }

      env {
        name  = "mongo-server-selection-timeout"
        value = var.mil_payment_notice_mongo_server_selection_timeout
      }

      env {
        name  = "node.soap-service.url"
        value = var.install_nodo_mock ? "${azurerm_api_management.mil.gateway_url}/${var.mock_nodo_path}" : var.nodo_soap_url
      }

      env {
        name  = "node.soap-client.connect-timeout"
        value = var.mil_payment_notice_node_soap_client_connect_timeout
      }

      env {
        name  = "node.soap-client.read-timeout"
        value = var.mil_payment_notice_node_soap_client_read_timeout
      }

      env {
        name        = "node.soap-client.apim-subscription-key"
        secret_name = "node-soap-subscription-key"
      }

      env {
        name  = "node.rest-service.url"
        value = var.install_nodo_mock ? "${azurerm_api_management.mil.gateway_url}/${var.mock_nodo_path}" : var.nodo_rest_url
      }

      env {
        name        = "node-rest-client-subscription-key"
        secret_name = "node-rest-subscription-key"
      }

      env {
        name  = "paymentnotice.rest-client.connect-timeout"
        value = var.mil_payment_notice_rest_client_connect_timeout
      }

      env {
        name  = "paymentnotice.rest-client.read-timeout"
        value = var.mil_payment_notice_rest_client_read_timeout
      }

      env {
        name  = "paymentnotice.closepayment.max-retry"
        value = var.mil_payment_notice_closepayment_max_retry
      }

      env {
        name  = "paymentnotice.closepayment.retry-after"
        value = var.mil_payment_notice_closepayment_retry_after
      }

      env {
        name  = "paymentnotice.activatepayment.expiration-time"
        value = var.mil_payment_notice_activatepayment_expiration_time
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
        name        = "redis-connection-string"
        secret_name = "redis-connection-string"
      }

      env {
        name  = "mil.rest-service.url"
        value = azurerm_storage_account.conf.primary_blob_endpoint
      }

      env {
        name  = "paymentnotice.closepayment.location.base-url"
        value = "${azurerm_api_management.mil.gateway_url}/${var.mil_payment_notice_path}"
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
        value = "${azurerm_api_management.mil.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
      }
    }

    max_replicas = var.mil_payment_notice_max_replicas
    min_replicas = var.mil_payment_notice_min_replicas
  }

  secret {
    name  = "node-soap-subscription-key"
    value = data.azurerm_key_vault_secret.node_soap_subscription_key.value
  }

  secret {
    name  = "node-rest-subscription-key"
    value = data.azurerm_key_vault_secret.node_rest_subscription_key.value
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
    name  = "redis-connection-string"
    value = "rediss://:${azurerm_redis_cache.mil.primary_access_key}@${azurerm_redis_cache.mil.hostname}:${azurerm_redis_cache.mil.ssl_port}"
  }

  secret {
    name  = "kafka-connection-string-1"
    value = azurerm_eventhub_namespace.mil.default_primary_connection_string
  }

  secret {
    name  = "kafka-connection-string-2"
    value = azurerm_eventhub_namespace.mil.default_secondary_connection_string
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
# Assignement of role "Storage Blob Data Reader" to system-managed identity of
# container app, to use storage account.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "conf_storage_for_payment_notice" {
  scope                = azurerm_storage_account.conf.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_container_app.payment_notice.identity[0].principal_id
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "payment_notice_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-payment-notice' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-payment-notice - last hour logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "payment_notice" {
  name                  = "${local.project}-payment-notice"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "payment notice"
  description           = "Payment Notice Microservice for Multi-channel Integration Layer of SW Client Project"
  path                  = var.mil_payment_notice_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.payment_notice.ingress[0].fqdn}"
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mil_payment_notice_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "payment_notice" {
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.payment_notice.name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "payment_notice" {
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_api_management.mil.resource_group_name
  api_management_name      = azurerm_api_management.mil.name
  api_name                 = azurerm_api_management_api.payment_notice.name
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
      "Location",
      "Retry-After",
      "Max-Retries"
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
      "Location",
      "Retry-After",
      "Max-Retries"
    ]
  }
}
