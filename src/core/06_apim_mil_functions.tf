# API for mil-functions.
locals {
  mil_functions_ingress_fqdn = jsondecode(azurerm_resource_group_template_deployment.mil_functions.output_content).ingress_fqdn.value
  #mil_functions_ingress_fqdn = azurerm_container_app.mil_functions.ingress[0].fqdn
}

module "functions_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v5.1.0"
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

resource "azurerm_api_management_api_diagnostic" "functions_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.functions_api.name
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