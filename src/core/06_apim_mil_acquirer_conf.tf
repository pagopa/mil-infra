#
# API for mil-acquirer-conf
#
module "acquirer_conf_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.20.0"
  name                = "${local.project}-acquirer-conf"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Handling the configuration of an Acquirer for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = ""

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mil-acquirer-conf"

  display_name          = "acquirer conf"
  content_format        = "openapi-link"
  content_value         = var.mil_acquirer_conf_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getPspConfig"
      xml_content = templatefile("policies/mil-acquirer-conf-getPspConfig.xml",
        {
          storage_container_uri = "https://${azurerm_storage_account.conf.name}.blob.core.windows.net/${azurerm_storage_container.acquirers.name}/"
          #storage_container_uri = "https://${azurerm_private_dns_zone.storage.name}/${azurerm_storage_container.acquirers.name}/"
        }
      )
    }
  ]
}

resource "azurerm_api_management_api_diagnostic" "acquirer_conf_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.acquirer_conf_api.name
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
