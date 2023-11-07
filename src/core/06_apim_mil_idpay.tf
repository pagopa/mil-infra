#
# API for mil-idpay
#
module "idpay_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-idpay"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "IDPay Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_idpay.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-idpay"

  display_name          = "idpay"
  content_format        = "openapi-link"
  content_value         = var.mil_idpay_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

resource "azurerm_api_management_api_diagnostic" "idpay_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.idpay_api.name
  api_management_logger_id = module.apim.logger_id

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId",
      "SessionId"
    ]
  }

  frontend_response {
    body_bytes = 8192
    headers_to_log = [
      "Location",
      "Retry-After",
      "Max-Retries"
    ]
  }

  backend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId",
      "SessionId"
    ]
  }

  backend_response {
    body_bytes = 8192
    headers_to_log = [
      "Location",
      "Retry-After",
      "Max-Retries"
    ]
  }
}