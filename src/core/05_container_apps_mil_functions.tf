# Container App for mil-functions
locals {
  mil_functions_ca_name = "${local.project}-functions-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_functions" {
  name                = local.mil_functions_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  #lifecycle {
  #  ignore_changes = [
  #    template_content
  #  ]
  #}

  template_content = templatefile("templates/mil-functions.json",
    {
      name                           = local.mil_functions_ca_name,
      location                       = azurerm_resource_group.app.location,
      mongo_connection_string_1      = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2      = azurerm_cosmosdb_account.mil.connection_strings[1],
      managed_environment_id         = module.cae.id,
      image                          = var.mil_functions_image,
      quarkus_log_level              = var.mil_functions_quarkus_log_level,
      app_log_level                  = var.mil_functions_app_log_level,
      mongo_connect_timeout          = var.mil_functions_mongo_connect_timeout,
      mongo_read_timeout             = var.mil_functions_mongo_read_timeout,
      mongo_server_selection_timeout = var.mil_functions_mongo_server_selection_timeout,
      cpu                            = var.mil_functions_cpu,
      ephemeral_storage              = var.mil_functions_ephemeral_storage,
      memory                         = var.mil_functions_memory,
      max_replicas                   = var.mil_functions_max_replicas,
      min_replicas                   = var.mil_functions_min_replicas
    }
  )
}

output "mil_functions_ingress_fqdn" {
  value = jsondecode(azurerm_resource_group_template_deployment.mil_functions.output_content).ingress_fqdn.value
}