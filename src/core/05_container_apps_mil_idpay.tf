#
# Container App for mil-idpay
#
data "azurerm_key_vault_secret" "idpay_subscription_key" {
  name         = "idpay-subscription-key"
  key_vault_id = module.key_vault.id
}

locals {
  idpay_ca_name = "${local.project}-idpay-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_idpay" {
  name                = local.idpay_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  template_content = templatefile("templates/mil-idpay.json",
    {
      content_version                = "1.0.0.0",
      name                           = local.idpay_ca_name,
      location                       = azurerm_resource_group.app.location,
      image                          = var.mil_idpay_image,
      cpu                            = var.mil_idpay_cpu,
      ephemeral_storage              = var.mil_idpay_ephemeral_storage,
      memory                         = var.mil_idpay_memory,
      max_replicas                   = var.mil_idpay_max_replicas,
      min_replicas                   = var.mil_idpay_min_replicas,
      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
      idpay_subscription_key         = data.azurerm_key_vault_secret.idpay_subscription_key.value,
      managed_environment_id         = module.cae.id,
      quarkus_log_level              = var.mil_idpay_quarkus_log_level,
      app_log_level                  = var.mil_idpay_app_log_level,
      jwt_publickey_location         = var.mil_idpay_jwt_publickey_location,
      transaction_max_retry          = var.mil_idpay_transaction_max_retry,
      transaction_retry_after        = var.mil_idpay_transaction_retry_after,
      transaction_location_base_url  = var.mil_idpay_location_base_url,
      idpay_rest_api_url             = var.mil_idpay_idpay_rest_api_url,
      mongo_connect_timeout          = var.mil_idpay_mongo_connect_timeout,
      mongo_read_timeout             = var.mil_idpay_mongo_read_timeout,
      mongo_server_selection_timeout = var.mil_idpay_mongo_server_selection_timeout,
      azure_tenant_id                = data.azurerm_client_config.current.tenant_id,
      azure_client_id                = azuread_application.mil_services.application_id,
      azure_client_secret            = azuread_application_password.mil_services.value,
      ipzs_rest_api_url              = var.mil_idpay_ipzs_rest_api_url,
      azuread_rest_api_url           = var.mil_idpay_azuread_resp_api_url,
      azurekv_rest_api_url           = azurerm_key_vault.appl_key_vault.vault_uri,
      keysize                        = var.mil_idpay_keysize,
      cryptoperiod                   = var.mil_idpay_cryptoperiod
    }
  )
}

locals {
  mil_idpay_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_idpay.output_content).ingress_fqdn.value
}
