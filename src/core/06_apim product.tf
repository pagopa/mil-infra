# Product.
locals {
  product_id = "mil"
}

module "mil_product" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v4.1.0"
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
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v4.1.0"
  name                = "${local.project}-services"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Handling of end-user services for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.init_ca_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-functions"

  display_name          = "services"
  content_format        = "openapi-link"
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/functions.yaml"
  product_ids           = [local.product_id]
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
