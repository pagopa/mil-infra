#
# Container App for mil-auth
#
locals {
  auth_ca_name = "${local.project}-auth-ca"
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
      managed_environment_id = module.cae.id,
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

#output "mil_auth_ingress_fqdn" {
#  value = jsondecode(azurerm_resource_group_template_deployment.mil_auth.output_content).ingress_fqdn.value
#}
