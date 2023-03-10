# API for mil-payment-notice.
module "payment_notice_api__external__oauth" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v5.1.0"
  name                = "${local.project}-payment-notice-external-oauth"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Payment Notice Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${local.mil_payment_notice_ingress_fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "ext/aut/mil-payment-notice"

  display_name          = "payment notice - external - oauth"
  content_format        = "openapi-link"
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/payment-notice.yaml"
  product_ids           = [module.mil_product__external__oauth.product_id]
  subscription_required = false

  # TODO : POLICY TO VERIFY ACCESS TOKEN
  #api_operation_policies = [
  #  {
  #    operation_id = "getFee"
  #    xml_content = templatefile("policies/mil-fee-calculator-getFee.xml",
  #      {
  #        storage_container_uri = "https://${azurerm_storage_account.conf.name}.blob.core.windows.net/${azurerm_storage_container.acquirer_conf.name}/"
  #        #storage_container_uri = "https://${azurerm_private_dns_zone.storage.name}/${azurerm_storage_container.acquirer_conf.name}/"
  #      }
  #    )
  #  },
  #  {
  #    ...  
  #  }
  #]
}

resource "azurerm_api_management_api_diagnostic" "payment_notice_api__external__oauth" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.payment_notice_api__external__oauth.name
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
