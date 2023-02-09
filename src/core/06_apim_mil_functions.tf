# API for mil-functions.
locals {
  mil_functions_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_functions.output_content).ingress_fqdn.value
}

module "functions_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v4.1.12"
  name                = "${local.project}-services"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Handling of end-user services for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.mil_functions_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-functions"

  display_name          = "services"
  content_format        = "openapi-link"
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/functions.yaml"
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}