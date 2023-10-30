#
# Container App for mil-idpay
#
data "azurerm_key_vault_secret" "idpay_subscription_key" {
  name         = "idpay-subscription-key"
  key_vault_id = module.key_vault.id
}

#locals {
#  idpay_ca_name = "${local.project}-idpay-ca"
#}
#
#resource "azurerm_resource_group_template_deployment" "mil_idpay" {
#  name                = local.idpay_ca_name
#  resource_group_name = azurerm_resource_group.app.name
#  deployment_mode     = "Incremental"
#  tags                = var.tags
#
#  template_content = templatefile("templates/mil-idpay.json",
#    {
#      content_version                = "1.0.0.0",
#      name                           = local.idpay_ca_name,
#      location                       = azurerm_resource_group.app.location,
#      image                          = var.mil_idpay_image,
#      cpu                            = var.mil_idpay_cpu,
#      ephemeral_storage              = var.mil_idpay_ephemeral_storage,
#      memory                         = var.mil_idpay_memory,
#      max_replicas                   = var.mil_idpay_max_replicas,
#      min_replicas                   = var.mil_idpay_min_replicas,
#      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
#      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
#      idpay_subscription_key         = data.azurerm_key_vault_secret.idpay_subscription_key.value,
#      managed_environment_id         = module.cae.id,
#      quarkus_log_level              = var.mil_idpay_quarkus_log_level,
#      app_log_level                  = var.mil_idpay_app_log_level,
#      jwt_publickey_location         = var.mil_idpay_jwt_publickey_location,
#      transaction_max_retry          = var.mil_idpay_transaction_max_retry,
#      transaction_retry_after        = var.mil_idpay_transaction_retry_after,
#      transaction_location_base_url  = var.mil_idpay_location_base_url,
#      idpay_rest_api_url             = var.mil_idpay_idpay_rest_api_url,
#      mongo_connect_timeout          = var.mil_idpay_mongo_connect_timeout,
#      mongo_read_timeout             = var.mil_idpay_mongo_read_timeout,
#      mongo_server_selection_timeout = var.mil_idpay_mongo_server_selection_timeout,
#      azure_tenant_id                = data.azurerm_client_config.current.tenant_id,
#      azure_client_id                = azuread_application.mil_services.application_id,
#      azure_client_secret            = azuread_application_password.mil_services.value,
#      ipzs_rest_api_url              = var.mil_idpay_ipzs_rest_api_url,
#      azuread_rest_api_url           = var.mil_idpay_azuread_resp_api_url,
#      azurekv_rest_api_url           = azurerm_key_vault.appl_key_vault.vault_uri,
#      keysize                        = var.mil_idpay_keysize,
#      cryptoperiod                   = var.mil_idpay_cryptoperiod
#    }
#  )
#}

#locals {
#  mil_idpay_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_idpay.output_content).ingress_fqdn.value
#}

resource "azurerm_container_app" "mil_idpay" {
  name                         = "${local.project}-idpay-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id # module.cae.id,
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