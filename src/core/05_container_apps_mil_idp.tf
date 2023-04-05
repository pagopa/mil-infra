# Container App for mil-idp
locals {
  idp_ca_name = "${local.project}-idp-ca"
}

resource "azurerm_resource_group_template_deployment" "mil_idp" {
  name                = local.idp_ca_name
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  tags                = var.tags

  template_content = templatefile("templates/mil-idp.json",
    {
      content_version          = "1.0.0.1",
      name                     = local.idp_ca_name,
      location                 = azurerm_resource_group.app.location,
      redis_primary_access_key = module.redis_cache.primary_access_key,
      redis_hostname           = module.redis_cache.hostname,
      redis_ssl_port           = module.redis_cache.ssl_port,
      managed_environment_id   = module.cae.id,

      quarkus_log_level = var.mil_idp_quarkus_log_level,
      app_log_level     = var.mil_idp_app_log_level,
      cryptoperiod      = var.mil_idp_cryptoperiod,
      keysize           = var.mil_idp_keysize,
      issuer            = var.mil_idp_issuer,
      access_audience   = var.mil_idp_access_audience,
      access_duration   = var.mil_idp_access_duration,
      refresh_audience  = var.mil_idp_refresh_audience,
      refresh_duration  = var.mil_idp_refresh_duration,

      image             = var.mil_idp_image,
      cpu               = var.mil_idp_cpu,
      ephemeral_storage = var.mil_idp_ephemeral_storage,
      memory            = var.mil_idp_memory,
      max_replicas      = var.mil_idp_max_replicas,
      min_replicas      = var.mil_idp_min_replicas
    }
  )
}

locals {
  mil_idp_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_idp.output_content).ingress_fqdn.value
}

#output "mil_idp_ingress_fqdn" {
#  value = jsondecode(azurerm_resource_group_template_deployment.mil_idp.output_content).ingress_fqdn.value
#}
