#
# API for mil-auth
#
module "auth_new_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-auth-new"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Authorization Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_auth_new.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-auth-new"

  display_name          = "auth-new"
  content_format        = "openapi-link"
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-auth/main/src/main/resources/META-INF/openapi.yaml" # var.mil_auth_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

resource "azurerm_api_management_api_diagnostic" "auth_new_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.auth_new_api.name
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
