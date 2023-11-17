# ==============================================================================
# This file contains stuff needed to run mil-idpay microservice.
# ADEGUARE A MIL-PAYMENT-NOTICE PER QUANTO RIGUARDA IL RECUPERO DELLE URL
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "mil_idpay_armored_key_vault" {
  description = "If true the key vault will be protected with a private link."
  type        = bool
}

variable "mil_idpay_image" {
  type = string
}

variable "mil_idpay_cpu" {
  type    = number
  default = 1
}

variable "mil_idpay_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_idpay_max_replicas" {
  type    = number
  default = 10
}

variable "mil_idpay_min_replicas" {
  type    = number
  default = 1
}

variable "mil_idpay_openapi_descriptor" {
  type = string
}

variable "mil_idpay_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_idpay_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_idpay_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_idpay_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_idpay_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_idpay_transaction_max_retry" {
  type    = number
  default = 10
}

variable "mil_idpay_transaction_retry_after" {
  type    = number
  default = 1
}

variable "mil_idpay_location_base_url" {
  type = string
}

variable "mil_idpay_idpay_rest_api_url" {
  type = string
}

variable "mil_idpay_jwt_publickey_location" {
  type = string
}

variable "mil_idpay_ipzs_rest_api_url" {
  type = string
}

variable "mil_idpay_cryptoperiod" {
  type    = number
  default = 86400000
}

variable "mil_idpay_keysize" {
  type    = number
  default = 4096
}

variable "mil_idpay_path" {
  type    = string
  default = "mil-idpay"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "idpayTransactions" {
  account_name        = azurerm_cosmosdb_mongo_database.mil.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mil.name
  name                = "idpayTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mil.resource_group_name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "transactionId"
    ]
    unique = false
  }

  index {
    keys = [
      "idpayTransaction.terminalId",
      "idpayTransaction.merchantId",
      "idpayTransaction.channel",
      "idpayTransaction.acquirerId",
      "idpayTransaction.timestamp",
      "idpayTransaction.status"
    ]
    unique = false
  }
}

# ------------------------------------------------------------------------------
# Key vault for cryptographics operations.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "idpay_key_vault" {
  name                          = "${local.project}-idpay-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  sku_name                      = "premium"
  public_network_access_enabled = var.mil_idpay_armored_key_vault ? false : true
  enable_rbac_authorization     = true
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from APP SUBNET (containing Container Apps) to the key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "idpay_key_vault_pep" {
  count               = var.mil_idpay_armored_key_vault ? 1 : 0
  name                = "${local.project}-idpay-kv-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-idpay-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-idpay-kv-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault[0].id]
  }

  private_service_connection {
    name                           = "${local.project}-idpay-kv-psc"
    private_connection_resource_id = azurerm_key_vault.idpay_key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

# ------------------------------------------------------------------------------
# Get API key for IDPay from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "idpay_subscription_key" {
  name         = "idpay-subscription-key"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Get password for keystore containing the client certificate for IDPay from key
# vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "idpay_client_keystore_pwd" {
  name         = "idpay-client-keystore-pwd"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mil_idpay" {
  provider                     = myazurerm
  name                         = "${local.project}-idpay-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mil-idpay"
      image  = var.mil_idpay_image
      cpu    = var.mil_idpay_cpu
      memory = var.mil_idpay_memory

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
        name        = "idpay-rest-api.subscription-key"
        secret_name = "idpay-subscription-key"
      }

      env {
        name  = "quarkus-log-level"
        value = var.mil_idpay_quarkus_log_level
      }

      env {
        name  = "app-log-level"
        value = var.mil_idpay_app_log_level
      }

      env {
        name  = "jwt-publickey-location"
        value = "${module.apim.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
      }

      env {
        name  = "transaction.max-retry"
        value = var.mil_idpay_transaction_max_retry
      }

      env {
        name  = "transaction.retry-after"
        value = var.mil_idpay_transaction_retry_after
      }

      env {
        name  = "transaction.location.base-url"
        value = "${module.apim.gateway_url}/${var.mil_idpay_path}"
      }

      env {
        name  = "idpay-rest-api.url"
        value = var.install_idpay_ipzs_mock ? "${module.apim.gateway_url}/${var.mock_idpay_ipzs_path}" : var.mil_idpay_idpay_rest_api_url
      }

      env {
        name  = "mongo.connect-timeout"
        value = var.mil_idpay_mongo_connect_timeout
      }
      env {
        name  = "mongo.read-timeout"
        value = var.mil_idpay_mongo_read_timeout
      }

      env {
        name  = "mongo.server-selection-timeout"
        value = var.mil_idpay_mongo_server_selection_timeout
      }

      env {
        name  = "ipzs-rest-api.url"
        value = var.install_idpay_ipzs_mock ? "${module.apim.gateway_url}/${var.mock_idpay_ipzs_path}" : var.mil_idpay_ipzs_rest_api_url
      }

      env {
        name  = "idpay.keysize"
        value = var.mil_idpay_keysize
      }

      env {
        name  = "idpay.cryptoperiod"
        value = var.mil_idpay_cryptoperiod
      }

      env {
        name = "CLIENT_KEYSTORE"
        value = "/mnt/secrets/idpay-client.jks"
      }

      env {
        name        = "PSW_KEYSTORE"
        secret_name = "idpay-client-keystore-pwd"
      }

      volume_mounts {
        name = "secretsasfiles"
        path = "/mnt/secrets"
      }
    }

    max_replicas = var.mil_idpay_max_replicas
    min_replicas = var.mil_idpay_min_replicas

    volume {
      name = "secretsasfiles"
      storage_type = "Secret"
    }
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

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.connection_strings[1]
  }

  secret {
    name  = "idpay-subscription-key"
    value = data.azurerm_key_vault_secret.idpay_subscription_key.value
  }

  secret {
    name  = "idpay-client-keystore-pwd"
    value = data.azurerm_key_vault_secret.idpay_client_keystore_pwd.value
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "mil_idpay_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-idpay' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-idpay - last hour logs ***"
}

# ------------------------------------------------------------------------------
# Assignement of role "Key Vault Crypto Officer" to system-managed identity of
# container app, to use key vault.
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "idpay_kv" {
  scope                = azurerm_key_vault.idpay_key_vault.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_container_app.mil_idpay.identity[0].principal_id
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
module "idpay_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-idpay"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "IDPay Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_idpay.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = var.mil_idpay_path
  
  display_name          = "idpay"
  content_format        = "openapi-link"
  content_value         = var.mil_idpay_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "idpay_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.idpay_api.name
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
