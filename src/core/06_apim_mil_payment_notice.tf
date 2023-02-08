# API for mil-payment-notice.
locals {
  mil_payment_notice_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_payment_notice.output_content).ingress_fqdn.value
}

module "payment_notice_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v3.5.1"
  name                = "${local.project}-payment-notice"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Payment Notice Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.mil_payment_notice_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-payment-notice"

  display_name          = "services"
  content_format        = "openapi-link"
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/payment-notice.yaml"
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}
