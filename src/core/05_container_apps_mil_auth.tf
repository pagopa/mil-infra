#
# Container App for mil-auth
#
locals {
  auth_ca_name = "${local.project}-auth-ca-2"
}

resource "azurerm_resource_group_template_deployment" "mil_auth" {
  name                = local.auth_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  template_content = templatefile("templates/mil-auth.json",
    {
      content_version        = "1.0.0.0",
      name                   = local.auth_ca_name,
      location               = azurerm_resource_group.app.location,
      azure_tenant_id        = data.azurerm_client_config.current.tenant_id,
      azure_client_id        = azuread_application.mil_services.application_id,
      azure_client_secret    = azuread_application_password.mil_services.value,
      managed_environment_id = azurerm_container_app_environment.mil.id, # module.cae.id,
      quarkus_log_level      = var.mil_auth_quarkus_log_level,
      app_log_level          = var.mil_auth_app_log_level,
      cryptoperiod           = var.mil_auth_cryptoperiod,
      keysize                = var.mil_auth_keysize,
      access_duration        = var.mil_auth_access_duration,
      refresh_duration       = var.mil_auth_refresh_duration,
      data_url               = azurerm_storage_account.conf.primary_blob_endpoint,
      keyvault_url           = azurerm_key_vault.appl_key_vault.vault_uri,
      keyvault_api_version   = var.mil_auth_azure_keyvault_api_version,
      image                  = var.mil_auth_image,
      cpu                    = var.mil_auth_cpu,
      ephemeral_storage      = var.mil_auth_ephemeral_storage,
      memory                 = var.mil_auth_memory,
      max_replicas           = var.mil_auth_max_replicas,
      min_replicas           = var.mil_auth_min_replicas
    }
  )
}

locals {
  mil_auth_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_auth.output_content).ingress_fqdn.value
}

resource "azurerm_container_app" "mil_auth_new" {
  name                         = "${local.project}-auth-new-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mil-auth-new"
      image  = "ghcr.io/pagopa/mil-auth:refs_heads_rbac_for_storage_fix" # var.mil_auth_image
      cpu    = 1 # var.mil_auth_cpu
      memory = "2Gi" # var.mil_auth_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "auth.quarkus-log-level"
        value = var.mil_auth_quarkus_log_level
      }

      env {
        name  = "auth.quarkus-rest-client-logging-scope"
        value = "all"
      }

      env {
        name  = "auth.app-log-level"
        value = var.mil_auth_app_log_level
      }

      env {
        name  = "auth.cryptoperiod"
        value = var.mil_auth_cryptoperiod
      }

      env {
        name  = "auth.keysize"
        value = var.mil_auth_keysize
      }

      env {
        name  = "auth.access.duration"
        value = var.mil_auth_access_duration
      }

      env {
        name  = "auth.refresh.duration"
        value = var.mil_auth_refresh_duration
      }

      env {
        name  = "auth.data.url"
        value = azurerm_storage_account.auth.primary_blob_endpoint
        #value = azurerm_private_dns_zone.auth_storage.soa_record[0].fqdn
      }

      env {
        name  = "auth.keyvault.url"
        value = azurerm_key_vault.auth_key_vault.vault_uri
      }

      env {
        name  = "auth.keyvault.api-version"
        value = var.mil_auth_azure_keyvault_api_version
      }
    }

    max_replicas = var.mil_auth_max_replicas
    min_replicas = var.mil_auth_min_replicas
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

  tags = var.tags
}

resource "azurerm_role_assignment" "mil_auth_2_auth_kv" {
  scope                = azurerm_key_vault.auth_key_vault.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_container_app.mil_auth_new.identity[0].principal_id
}

resource "azurerm_role_assignment" "mil_auth_2_auth_st" {
  scope                = azurerm_storage_account.auth.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_container_app.mil_auth_new.identity[0].principal_id
}
