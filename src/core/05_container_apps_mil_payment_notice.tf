# Container App for mil-payment-notice
data "azurerm_key_vault_secret" "node_soap_subscription_key" {
  name         = "node-soap-subscription-key"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "node_rest_subscription_key" {
  name         = "node-rest-subscription-key"
  key_vault_id = module.key_vault.id
}


locals {
  payment_notice_ca_name = "${local.project}-payment-notice-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_payment_notice" {
  name                = local.payment_notice_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  #lifecycle {
  #  ignore_changes = [
  #    template_content
  #  ]
  #}

  template_content = templatefile("templates/mil-payment-notice.json",
    {
      content_version                  = "1.0.0.1",
      name                             = local.payment_notice_ca_name,
      location                         = azurerm_resource_group.app.location,
      mongo_connection_string_1        = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2        = azurerm_cosmosdb_account.mil.connection_strings[1],
      redis_primary_access_key         = module.redis_cache.primary_access_key,
      redis_hostname                   = module.redis_cache.hostname,
      redis_ssl_port                   = module.redis_cache.ssl_port,
      managed_environment_id           = module.cae.id,
      node_soap_subscription_key       = data.azurerm_key_vault_secret.node_soap_subscription_key.value,
      node_rest_subscription_key       = data.azurerm_key_vault_secret.node_rest_subscription_key.value,
      quarkus_log_level                = var.mil_payment_notice_quarkus_log_level,
      app_log_level                    = var.mil_payment_notice_app_log_level,
      mongo_connect_timeout            = var.mil_payment_notice_mongo_connect_timeout,
      mongo_read_timeout               = var.mil_payment_notice_mongo_read_timeout,
      mongo_server_selection_timeout   = var.mil_payment_notice_mongo_server_selection_timeout,
      node_soap_service_url            = var.mil_payment_notice_node_soap_service_url,
      node_soap_client_connect_timeout = var.mil_payment_notice_node_soap_client_connect_timeout,
      node_soap_client_read_timeout    = var.mil_payment_notice_node_soap_client_read_timeout,
      node_rest_service_url            = var.mil_payment_notice_node_rest_service_url,
      rest_client_connect_timeout      = var.mil_payment_notice_rest_client_connect_timeout,
      rest_client_read_timeout         = var.mil_payment_notice_rest_client_read_timeout,
      close_payment_max_retry          = var.mil_payment_notice_close_payment_max_retry,
      closepayment_retry_after         = var.mil_payment_notice_closepayment_retry_after,
      activatepayment_expiration_time  = var.mil_payment_notice_activatepayment_expiration_time,
      image                            = var.mil_payment_notice_image,
      cpu                              = var.mil_payment_notice_cpu,
      ephemeral_storage                = var.mil_payment_notice_ephemeral_storage,
      memory                           = var.mil_payment_notice_memory,
      max_replicas                     = var.mil_payment_notice_max_replicas,
      min_replicas                     = var.mil_payment_notice_min_replicas
    }
  )
}

#output "mil_payment_notice_ingress_fqdn" {
#  value = jsondecode(azurerm_resource_group_template_deployment.mil_payment_notice.output_content).ingress_fqdn.value
#}
