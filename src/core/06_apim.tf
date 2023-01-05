# Log Analytics Workspace.
#resource "azurerm_log_analytics_workspace" "apim_log" {
#  name                = "${local.project}-apim-log"
#  resource_group_name = azurerm_resource_group.integration_rg.name
#  location            = azurerm_resource_group.integration_rg.location
#  tags                = var.tags
#}

# API Manager.
module "apim" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v3.4.5"
  name                 = "${local.project}-apim"
  resource_group_name  = azurerm_resource_group.integration_rg.name
  location             = azurerm_resource_group.integration_rg.location
  subnet_id            = azurerm_subnet.apim.id
  sku_name             = var.apim_sku
  virtual_network_type = "External"
  sign_up_enabled      = false
  lock_enable          = var.apim_lock_enable
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  redis_cache_id       = var.apim_redis_cache_id
  tags                 = var.tags
}

# Product.
locals {
  product_id = "mil"
}

module "mil_product" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v3.4.5"
  product_id            = local.product_id
  display_name          = "Multi-channel Integration Layer"
  description           = "Multi-channel Integration Layer for SW Client Project"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = false
  approval_required     = false
}

# API for mil-functions.
locals {
  init_ca_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.init_ca.output_content).ingress_fqdn.value
}

module "functions_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v3.4.5"
  name                = "${local.project}-services"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Handling of end-user services for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.init_ca_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-functions"

  display_name = "services"

  content_format = "openapi-link"
  content_value  = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/functions.yaml"

  product_ids = [local.product_id]

  subscription_required = false
}

# Subscription for tracing. For DEV only.
resource "azurerm_api_management_subscription" "tracing" {
  count               = var.env_short == "d" ? 1 : 0
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  display_name        = "Tracing"
  state               = "active"
  allow_tracing       = true
}