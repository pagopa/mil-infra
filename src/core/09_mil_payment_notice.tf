# ==============================================================================
# This file contains stuff needed to run mil-payment-notice microservice.
# The resources in this file are used by mil-payment-notice only.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_payment_notice_armored_redis" {
  description = "If true Redis will be protected with a private link."
  type        = bool
}

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
# Private endpoint from APP SUBNET (containing Container Apps) to Redis.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "redis" {
  count               = var.mil_payment_notice_armored_redis ? 1 : 0
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  count                 = var.mil_payment_notice_armored_redis ? 1 : 0
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.redis[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

# ------------------------------------------------------------------------------
# Redis cache.
# ------------------------------------------------------------------------------
module "redis_cache" {
  source                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v7.14.0"
  name                          = "${local.project}-redis"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  capacity                      = 1
  enable_non_ssl_port           = false
  family                        = "C"
  sku_name                      = "Basic"
  enable_authentication         = true
  public_network_access_enabled = var.mil_payment_notice_armored_redis ? false : true
  redis_version                 = 6
  zones                         = null

  private_endpoint = {
    enabled              = var.mil_payment_notice_armored_redis ? true : false
    virtual_network_id   = var.mil_payment_notice_armored_redis ? azurerm_private_dns_zone_virtual_network_link.redis[0].virtual_network_id : "dontcare"
    subnet_id            = azurerm_subnet.app.id
    private_dns_zone_ids = [var.mil_payment_notice_armored_redis ? azurerm_private_dns_zone.redis[0].id : "dontcare"]
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Get API key for SOAP endpoint of Nodo from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "node_soap_subscription_key" {
  name         = "node-soap-subscription-key"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Get API key for REST endpoint of Nodo from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "node_rest_subscription_key" {
  name         = "node-rest-subscription-key"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mil_payment_notice" {
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
        value = var.install_nodo_mock ? "${module.apim.gateway_url}/${var.mock_nodo_path}" : var.nodo_soap_url
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
        value = var.install_nodo_mock ? "${module.apim.gateway_url}/${var.mock_nodo_path}" : var.nodo_rest_url
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
        value = "${module.apim.gateway_url}/${var.mil_payment_notice_path}"
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
    value = "rediss://:${module.redis_cache.primary_access_key}@${module.redis_cache.hostname}:${module.redis_cache.ssl_port}"
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
resource "azurerm_log_analytics_query_pack_query" "payment_notice_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-payment-notice' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-payment-notice - last hour logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
module "payment_notice_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-payment-notice"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Payment Notice Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_payment_notice.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = var.mil_payment_notice_path

  display_name          = "payment notice"
  content_format        = "openapi-link"
  content_value         = var.mil_payment_notice_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "payment_notice_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.payment_notice_api.name
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
