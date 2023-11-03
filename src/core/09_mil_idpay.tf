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

variable "mil_idpay_azuread_resp_api_url" {
  type    = string
  default = "https://login.microsoftonline.com"
}

variable "mil_idpay_cryptoperiod" {
  type    = number
  default = 86400000
}

variable "mil_idpay_keysize" {
  type    = number
  default = 4096
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
# Definition of an application to which assign grants.
# THIS WILL BE REMOVED WHEN mil-idpay WILL USE SYSTEM-MANAGED IDENTITY. 
# ------------------------------------------------------------------------------
resource "azuread_application" "mil_services" {
  display_name = "${local.project}-services"

  required_resource_access {
    # Microsoft Graph
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      # User.Read
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  required_resource_access {
    # Azure Key Vault
    resource_app_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

    resource_access {
      # user_impersonation
      id   = "f53da476-18e3-4152-8e01-aec403e6edc0"
      type = "Scope"
    }
  }

  device_only_auth_enabled       = false
  fallback_public_client_enabled = false
  group_membership_claims        = []
  identifier_uris                = []
  oauth2_post_response_required  = false
  owners                         = []
  prevent_duplicate_names        = false
  sign_in_audience               = "AzureADMyOrg"

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 1
  }

  feature_tags {
    custom_single_sign_on = false
    enterprise            = false
    gallery               = false
    hide                  = false
  }

  public_client {
    redirect_uris = []
  }

  single_page_application {
    redirect_uris = []
  }

  web {
    redirect_uris = []

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }
}

# ------------------------------------------------------------------------------
# Definition of the service principal for the application.
# THIS WILL BE REMOVED WHEN mil-idpay WILL USE SYSTEM-MANAGED IDENTITY. 
# ------------------------------------------------------------------------------
resource "azuread_service_principal" "mil_services" {
  application_id = azuread_application.mil_services.application_id
  use_existing   = true
}

# ------------------------------------------------------------------------------
# Definition of the credentials for the application.
# THIS WILL BE REMOVED WHEN mil-idpay WILL USE SYSTEM-MANAGED IDENTITY. 
# ------------------------------------------------------------------------------
resource "azuread_application_password" "mil_services" {
  application_object_id = azuread_application.mil_services.object_id
  display_name          = "${local.project}-services"
  end_date_relative     = "262800h"
}

# ------------------------------------------------------------------------------
# Key vault for cryptographics operations.
# THE DEFINITION OF THIS KEY VAUL WILL BE ALIGNED TO auth_key_vault WHEN
# mil-idpay WILL USE SYSTEM-MANAGED IDENTITY.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "appl_key_vault" {
  name                          = "${local.project}-appl-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  sku_name                      = "premium"
  public_network_access_enabled = var.mil_idpay_armored_key_vault ? false : true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Rotate",
      "Encrypt",
      "Decrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
      "Release"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azuread_service_principal.mil_services.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Rotate",
      "Encrypt",
      "Decrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
      "Release"
    ]

    secret_permissions = []

    certificate_permissions = []
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
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mil_idpay" {
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
        value = var.mil_idpay_jwt_publickey_location
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
        value = var.mil_idpay_location_base_url
      }

      env {
        name  = "idpay-rest-api.url"
        value = var.mil_idpay_idpay_rest_api_url
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
        name        = "azuread_tenant_id"
        secret_name = "azure-tenant-id"
      }

      env {
        name        = "azuread_client_id"
        secret_name = "azure-client-id"
      }

      env {
        name        = "azuread_client_secret"
        secret_name = "azure-client-secret"
      }

      env {
        name  = "ipzs-rest-api.url"
        value = var.mil_idpay_ipzs_rest_api_url
      }

      env {
        name  = "azuread-rest-api.url"
        value = var.mil_idpay_azuread_resp_api_url
      }

      env {
        name  = "azurekv-rest-api.url"
        value = azurerm_key_vault.appl_key_vault.vault_uri
      }

      env {
        name  = "idpay.keysize"
        value = var.mil_idpay_keysize
      }

      env {
        name  = "idpay.cryptoperiod"
        value = var.mil_idpay_cryptoperiod
      }
    }

    max_replicas = var.mil_idpay_max_replicas
    min_replicas = var.mil_idpay_min_replicas
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
      revision_suffix = formatdate("YYYYMMDDhhmmssZZZZ", timestamp())
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
    name  = "azure-tenant-id"
    value = data.azurerm_client_config.current.tenant_id
  }

  secret {
    name  = "azure-client-id"
    value = azuread_application.mil_services.application_id
  }

  secret {
    name  = "azure-client-secret"
    value = azuread_application_password.mil_services.value
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
  path = "mil-idpay"

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
