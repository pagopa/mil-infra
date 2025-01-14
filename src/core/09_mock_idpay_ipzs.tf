# ==============================================================================
# This file contains stuff needed to run idpay-ipzs-mock.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "install_idpay_mock" {
  description = "If true the mock of the IDPay and IPZS will be installed."
  type        = bool
  default     = false
}

variable "install_ipzs_mock" {
  description = "If true the mock of the IDPay and IPZS will be installed."
  type        = bool
  default     = false
}

variable "mock_idpay_ipzs_image" {
  type    = string
  default = "ghcr.io/pagopa/idpay-ipzs-mock:latest"
}

variable "mock_idpay_ipzs_cpu" {
  type    = number
  default = 1
}

variable "mock_idpay_ipzs_memory" {
  type    = string
  default = "2Gi"
}

variable "mock_idpay_ipzs_max_replicas" {
  type    = number
  default = 5
}

variable "mock_idpay_ipzs_min_replicas" {
  type    = number
  default = 1
}

variable "mock_idpay_ipzs_openapi_descriptor" {
  type    = string
  default = "https://raw.githubusercontent.com/pagopa/idpay-ipzs-mock/main/src/main/resources/META-INF/openapi.yml"
}

variable "mock_idpay_ipzs_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mock_idpay_ipzs_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mock_idpay_ipzs_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mock_idpay_ipzs_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mock_idpay_ipzs_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mock_idpay_ipzs_path" {
  type    = string
  default = "idpay-ipzs-mock"
}

variable "mock_idpay_rest_api_url" {
  type = string
}

variable "mock_ipzs_call_idpay_to_link_user_to_trx" {
  type    = string
  default = "no"
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mock_idpay" {
  count               = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "idpay"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collections.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "initiatives" {
  count               = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  account_name        = azurerm_cosmosdb_mongo_database.mock_idpay[0].account_name
  database_name       = azurerm_cosmosdb_mongo_database.mock_idpay[0].name
  name                = "initiatives"
  resource_group_name = azurerm_cosmosdb_mongo_database.mock_idpay[0].resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "initiative.merchantId"
    ]
    unique = false
  }

  index {
    keys = [
      "initiative.initiativeId"
    ]
    unique = false
  }
}

resource "azurerm_cosmosdb_mongo_collection" "idpayLocalTransactions" {
  count               = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  account_name        = azurerm_cosmosdb_mongo_database.mock_idpay[0].account_name
  database_name       = azurerm_cosmosdb_mongo_database.mock_idpay[0].name
  name                = "idpayLocalTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mock_idpay[0].resource_group_name

  autoscale_settings {
    max_throughput = 1000
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "idpayLocalTransactions.merchantId"
    ]
    unique = false
  }
}

# ------------------------------------------------------------------------------
# Get API key for IDPay from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "idpay_subscription_key_for_ipzs" {
  name         = "idpay-subscription-key-ipzs"
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mock_idpay_ipzs" {
  count                        = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  name                         = "${local.project}-mock-idpay-ipzs-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mock-idpay-ipzs"
      image  = var.mock_idpay_ipzs_image
      cpu    = var.mock_idpay_ipzs_cpu
      memory = var.mock_idpay_ipzs_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "quarkus-log-level"
        value = var.mock_idpay_ipzs_quarkus_log_level
      }

      env {
        name  = "app-log-level"
        value = var.mock_idpay_ipzs_app_log_level
      }

      env {
        name  = "mongo.connect-timeout"
        value = var.mock_idpay_ipzs_mongo_connect_timeout
      }

      env {
        name  = "mongo.read-timeout"
        value = var.mock_idpay_ipzs_mongo_read_timeout
      }

      env {
        name  = "mongo.server-selection-timeout"
        value = var.mock_idpay_ipzs_mongo_server_selection_timeout
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
        name  = "idpay-rest-api.url"
        value = var.mock_idpay_rest_api_url
      }

      env {
        name        = "idpay-rest-api.subscription-key"
        secret_name = "idpay-subscription-key"
      }

      env {
        name  = "ipzs-call-idpay"
        value = var.mock_ipzs_call_idpay_to_link_user_to_trx
      }
    }

    max_replicas = var.mil_payment_notice_max_replicas
    min_replicas = var.mil_payment_notice_min_replicas
  }

  secret {
    name  = "mongo-connection-string-1"
    value = azurerm_cosmosdb_account.mil.primary_mongodb_connection_string
  }

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.secondary_mongodb_connection_string
  }

  secret {
    name  = "idpay-subscription-key"
    value = data.azurerm_key_vault_secret.idpay_subscription_key_for_ipzs.value
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
# API definition.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api" "mock_idpay_ipzs" {
  count                 = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  name                  = "${local.project}-idpay-ipzs-mock"
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  api_management_name   = azurerm_api_management.mil.name
  revision              = "1"
  display_name          = "mock-idpay-ipzs"
  description           = "IDPay and IPZS mock"
  path                  = var.mock_idpay_ipzs_path
  protocols             = ["https"]
  service_url           = "https://${azurerm_container_app.mock_idpay_ipzs[0].ingress[0].fqdn}"
  subscription_required = false

  import {
    content_format = "openapi-link"
    content_value  = var.mock_idpay_ipzs_openapi_descriptor
  }
}

resource "azurerm_api_management_product_api" "mock_idpay_ipzs" {
  count               = (var.install_idpay_mock || var.install_ipzs_mock) ? 1 : 0
  product_id          = azurerm_api_management_product.mil.product_id
  api_name            = azurerm_api_management_api.mock_idpay_ipzs[0].name
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
}