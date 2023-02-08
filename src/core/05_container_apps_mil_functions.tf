# Container App for mil-functions
locals {
  name = "${local.project}-functions-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_functions" {
  name                = local.name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags
  
  lifecycle {
    ignore_changes = [
      template_content
    ]
  }

  template_content = templatefile("templates/mil-functions.json",
    {
      name                                         = local.name,
      location                                     = azurerm_resource_group.app.location,
      mongo_connection_string_1                    = azurerm_cosmosdb_account.mil.connection_strings[0],
      mongo_connection_string_2                    = azurerm_cosmosdb_account.mil.connection_strings[1],
      managed_environment_id                       = module.cae.id,
      mil_functions_image                          = var.mil_functions_image,
      mil_functions_quarkus_log_level              = var.mil_functions_quarkus_log_level,
      mil_functions_app_log_level                  = var.mil_functions_app_log_level,
      mil_functions_mongo_connect_timeout          = var.mil_functions_mongo_connect_timeout,
      mil_functions_mongo_read_timeout             = var.mil_functions_mongo_read_timeout,
      mil_functions_mongo_server_selection_timeout = var.mil_functions_mongo_server_selection_timeout,
      mil_functions_cpu                            = var.mil_functions_cpu,
      mil_functions_ephemeral_storage              = var.mil_functions_ephemeral_storage,
      mil_functions_memory                         = var.mil_functions_memory,
      mil_functions_max_replicas                   = var.mil_functions_max_replicas,
      mil_functions_min_replicas                   = var.mil_functions_min_replicas
    }
  )
}

#output "mil_functions_ingress_fqdn" {
#  value = jsondecode(azurerm_resource_group_template_deployment.mil_functions.output_content).ingress_fqdn.value
#}