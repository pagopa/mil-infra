#
# Container App for idpay-ipzs-mock
#
locals {
  idpay_ipzs_mock_ca_name = "${local.project}-idpay-ipzs-mock-ca-2"
}

resource "azurerm_resource_group_template_deployment" "mil_idpay_ipzs_mock" {
  count               = (var.env_short == "d" || var.env_short == "u") ? 1 : 0
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
      managed_environment_id         = module.cae.id,
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
