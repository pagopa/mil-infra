# ==============================================================================
# This file contains stuff needed to run idpay-ipzs-mock.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "install_idpay_ipzs_mock" {
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

# ------------------------------------------------------------------------------
# CosmosDB Mongo database.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mock_idpay" {
  count               = var.install_idpay_ipzs_mock ? 1 : 0
  account_name        = azurerm_cosmosdb_account.mil.name
  name                = "idpay"
  resource_group_name = azurerm_cosmosdb_account.mil.resource_group_name
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collections.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "initiatives" {
  count               = var.install_idpay_ipzs_mock ? 1 : 0
  account_name        = azurerm_cosmosdb_mongo_database.mock_idpay[0].account_name
  database_name       = azurerm_cosmosdb_mongo_database.mock_idpay[0].name
  name                = "initiatives"
  resource_group_name = azurerm_cosmosdb_mongo_database.mock_idpay[0].resource_group_name

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
  count               = var.install_idpay_ipzs_mock ? 1 : 0
  account_name        = azurerm_cosmosdb_mongo_database.mock_idpay[0].account_name
  database_name       = azurerm_cosmosdb_mongo_database.mock_idpay[0].name
  name                = "idpayLocalTransactions"
  resource_group_name = azurerm_cosmosdb_mongo_database.mock_idpay[0].resource_group_name

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
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mock_idpay_ipzs" {
  count                        = var.install_idpay_ipzs_mock ? 1 : 0
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
        name  = "mongo-connect-timeout"
        value = var.mock_idpay_ipzs_mongo_connect_timeout
      }

      env {
        name  = "mongo-read-timeout"
        value = var.mock_idpay_ipzs_mongo_read_timeout
      }

      env {
        name  = "mongo-server-selection-timeout"
        value = var.mock_idpay_ipzs_mongo_server_selection_timeout
      }

      env {
        name        = "mongo-connection-string-1"
        secret_name = "mongo-connection-string-1"
      }

      env {
        name        = "mongo-connection-string-2"
        secret_name = "mongo-connection-string-2"
      }
    }

    max_replicas = var.mil_payment_notice_max_replicas
    min_replicas = var.mil_payment_notice_min_replicas
  }

  secret {
    name  = "mongo-connection-string-1"
    value = azurerm_cosmosdb_account.mil.connection_strings[0]
  }

  secret {
    name  = "mongo-connection-string-2"
    value = azurerm_cosmosdb_account.mil.connection_strings[1]
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
module "mock_idpay_ipzs_api" {
  count               = var.install_idpay_ipzs_mock ? 1 : 0
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-idpay-ipzs-mock-2"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "IDPay and IPZS mock"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mock_idpay_ipzs[0].ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = "idpay-ipzs-mock"

  display_name          = "mock-idpay-ipzs"
  content_format        = "openapi-link"
  content_value         = var.mock_idpay_ipzs_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}