#
# API for idpay-ipzs-mock
#
module "idpay_ipzs_mock_api" {
  count               = var.env_short == "d" ? 1 : 0
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-idpay-ipzs-mock-2"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "IDPay and IPZS mock"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.mil_idpay_ipzs_mock_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "idpay-ipzs-mock"

  display_name          = "idpay-ipza-mock"
  content_format        = "openapi-link"
  content_value         = var.mil_idpay_ipzs_mock_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}
