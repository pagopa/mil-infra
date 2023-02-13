# Container App for mil-payment-notice
data "azurerm_key_vault_secret" "gec_subscription_key" {
  name         = "gec-subscription-key"
  key_vault_id = module.key_vault.id
}

locals {
  fee_calculator_ca_name = "${local.project}-fee-calculator-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_fee_calculator" {
  name                = local.fee_calculator_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      template_content
    ]
  }

  template_content = templatefile("templates/mil-fee-calculator.json",
    {
      name                           = local.fee_calculator_ca_name,
      location                       = azurerm_resource_group.app.location,
      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
      managed_environment_id         = module.cae.id,
      gec_subscription_key           = data.azurerm_key_vault_secret.gec_subscription_key.value,
      quarkus_log_level              = var.mil_fee_calculator_quarkus_log_level,
      app_log_level                  = var.mil_fee_calculator_app_log_level,
      mongo_connect_timeout          = var.mil_fee_calculator_mongo_connect_timeout,
      mongo_read_timeout             = var.mil_fee_calculator_mongo_read_timeout,
      mongo_server_selection_timeout = var.mil_fee_calculator_mongo_server_selection_timeout,
      gec_url                        = var.mil_fee_calculator_gec_url,
      gec_connect_timeout            = var.mil_fee_calculator_gec_connect_timeout,
      gec_read_timeout               = var.mil_fee_calculator_gec_read_timeout,
      image                          = var.mil_fee_calculator_image,
      cpu                            = var.mil_fee_calculator_cpu,
      ephemeral_storage              = var.mil_fee_calculator_ephemeral_storage,
      memory                         = var.mil_fee_calculator_memory,
      max_replicas                   = var.mil_fee_calculator_max_replicas,
      min_replicas                   = var.mil_fee_calculator_min_replicas
    }
  )
}

output "mil_fee_calculator_ingress_fqdn" {
  value = jsondecode(azurerm_resource_group_template_deployment.mil_fee_calculator.output_content).ingress_fqdn.value
}
