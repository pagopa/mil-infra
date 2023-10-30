#
# Container App for idpay-ipzs-mock
#
locals {
  idpay_ipzs_mock_ca_name = "${local.project}-idpay-ipzs-mock-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_idpay_ipzs_mock" {
  count               = var.env_short == "d" ? 1 : 0
  name                = local.idpay_ipzs_mock_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  template_content = templatefile("templates/idpay-ipzs-mock.json",
    {
      content_version                = "1.0.0.0",
      name                           = local.idpay_ipzs_mock_ca_name,
      location                       = azurerm_resource_group.app.location,
      image                          = var.mil_idpay_ipzs_mock_image,
      cpu                            = var.mil_idpay_ipzs_mock_cpu,
      ephemeral_storage              = var.mil_idpay_ipzs_mock_ephemeral_storage,
      memory                         = var.mil_idpay_ipzs_mock_memory,
      max_replicas                   = var.mil_idpay_ipzs_mock_max_replicas,
      min_replicas                   = var.mil_idpay_ipzs_mock_min_replicas,
      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
      managed_environment_id         = azurerm_container_app_environment.mil.id,
      quarkus_log_level              = var.mil_idpay_ipzs_mock_quarkus_log_level,
      app_log_level                  = var.mil_idpay_ipzs_mock_app_log_level,
      mongo_connect_timeout          = var.mil_idpay_ipzs_mock_mongo_connect_timeout,
      mongo_read_timeout             = var.mil_idpay_ipzs_mock_mongo_read_timeout,
      mongo_server_selection_timeout = var.mil_idpay_ipzs_mock_mongo_server_selection_timeout
    }
  )
}

locals {
  mil_idpay_ipzs_mock_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_idpay_ipzs_mock[0].output_content).ingress_fqdn.value
}

#resource "azurerm_container_app" "mil_idpay_ipzs_mock" {
#  name                         = "${local.project}-idpay-ipzs-mock-ca-2"
#  container_app_environment_id = azurerm_container_app_environment.mil.id
#  resource_group_name          = azurerm_resource_group.app.name
#  revision_mode                = "Multiple"
#
#  template {
#    container {
#      name   = "mil-idpay-ipzs-mock-ca"
#      image  = var.mil_idpay_ipzs_mock_image
#      cpu    = var.mil_idpay_ipzs_mock_cpu
#      memory = var.mil_idpay_ipzs_mock_memory
#
#      env {
#        name  = "TZ"
#        value = "Europe/Rome"
#      }
#
#      env {
#        name        = "mongo.connection-string-1"
#        secret_name = "mongo-connection-string-1"
#      }
#
#      env {
#        name        = "mongo.connection-string-2"
#        secret_name = "mongo-connection-string-2"
#      }
#
#      env {
#        name  = "quarkus-log-level"
#        value = var.mil_idpay_quarkus_log_level
#      }
#
#      env {
#        name  = "app-log-level"
#        value = var.mil_idpay_app_log_level
#      }
#
#      env {
#        name  = "mongo.connect-timeout"
#        value = var.mil_idpay_mongo_connect_timeout
#      }
#      env {
#        name  = "mongo.read-timeout"
#        value = var.mil_idpay_mongo_read_timeout
#      }
#
#      env {
#        name  = "mongo.server-selection-timeout"
#        value = var.mil_idpay_mongo_server_selection_timeout
#      }
#
#      env {
#        name        = "azuread_tenant_id"
#        secret_name = "azure-tenant-id"
#      }
#
#      env {
#        name        = "azuread_client_id"
#        secret_name = "azure-client-id"
#      }
#
#      env {
#        name        = "azuread_client_secret"
#        secret_name = "azure-client-secret"
#      }
#
#      env {
#        name  = "ipzs-rest-api.url"
#        value = var.mil_idpay_ipzs_rest_api_url
#      }
#
#      env {
#        name  = "azuread-rest-api.url"
#        value = var.mil_idpay_azuread_resp_api_url
#      }
#
#      env {
#        name  = "azurekv-rest-api.url"
#        value = azurerm_key_vault.appl_key_vault.vault_uri
#      }
#
#      env {
#        name  = "idpay.keysize"
#        value = var.mil_idpay_keysize
#      }
#
#      env {
#        name  = "idpay.cryptoperiod"
#        value = var.mil_idpay_cryptoperiod
#      }
#    }
#
#    max_replicas = var.mil_idpay_max_replicas
#    min_replicas = var.mil_idpay_min_replicas
#  }
#
#  identity {
#    type = "SystemAssigned"
#  }
#
#  ingress {
#    external_enabled = true
#    target_port      = 8080
#    transport        = "http"
#
#    traffic_weight {
#      latest_revision = true
#      percentage      = 100
#    }
#  }
#
#  secret {
#    name  = "mongo-connection-string-1"
#    value = azurerm_cosmosdb_account.mil.connection_strings[0]
#  }
#
#  secret {
#    name  = "mongo-connection-string-2"
#    value = azurerm_cosmosdb_account.mil.connection_strings[1]
#  }
#
#  tags = var.tags
#}
#