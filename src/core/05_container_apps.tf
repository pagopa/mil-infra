# Container Apps Environment.
module "cae" {
  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment?ref=v3.5.1"
  name                      = "${local.project}-cae"
  resource_group_name       = azurerm_resource_group.app.name
  location                  = azurerm_resource_group.app.location
  vnet_internal             = false
  subnet_id                 = azurerm_subnet.app.id
  log_destination           = "log-analytics"
  log_analytics_customer_id = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
  log_analytics_shared_key  = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  zone_redundant            = false
  tags                      = var.tags
}

# Container App.
locals {
  name = "${local.project}-init-ca"
}

resource "azurerm_resource_group_template_deployment" "init_ca" {
  name                = local.name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  template_content = templatefile("templates/init-ca.json",
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

#output "init_ca_ingress_fqdn" {
#  value = jsondecode(azurerm_resource_group_template_deployment.init_ca.output_content).ingress_fqdn.value
#}