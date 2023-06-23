#
# Container App for mil-preset
#
locals {
  preset_ca_name = "${local.project}-preset-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_preset" {
  name                = local.preset_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  #lifecycle {
  #  ignore_changes = [
  #    template_content
  #  ]
  #}

  template_content = templatefile("templates/mil-preset.json",
    {
      content_version                = "1.0.0.0",
      name                           = local.preset_ca_name,
      location                       = azurerm_resource_group.app.location,
      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
      managed_environment_id         = module.cae.id,
      quarkus_log_level              = var.mil_preset_quarkus_log_level,
      app_log_level                  = var.mil_preset_app_log_level,
      mongo_connect_timeout          = var.mil_preset_mongo_connect_timeout,
      mongo_read_timeout             = var.mil_preset_mongo_read_timeout,
      mongo_server_selection_timeout = var.mil_preset_mongo_server_selection_timeout,
      preset_location_base_url       = var.mil_preset_location_base_url,
      kafka_connection_string_1      = azurerm_eventhub_namespace.mil_evhns.default_primary_connection_string,
      kafka_connection_string_2      = azurerm_eventhub_namespace.mil_evhns.default_secondary_connection_string,
      eventhub_namespace             = azurerm_eventhub_namespace.mil_evhns.name,
      image                          = var.mil_preset_image,
      cpu                            = var.mil_preset_cpu,
      ephemeral_storage              = var.mil_preset_ephemeral_storage,
      memory                         = var.mil_preset_memory,
      max_replicas                   = var.mil_preset_max_replicas,
      min_replicas                   = var.mil_preset_min_replicas
    }
  )
}

locals {
  mil_preset_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_preset.output_content).ingress_fqdn.value
}
