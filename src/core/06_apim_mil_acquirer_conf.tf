# API for mil-acquirer-conf.
module "acquirer_conf_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v5.1.0"
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
  content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/acquirer-conf.yaml"
  product_ids           = [module.mil_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getPspConfig"
      xml_content = templatefile("policies/mil-acquirer-conf-getPspConfig.xml",
        {
          storage_container_uri = "https://${azurerm_storage_account.conf.name}.blob.core.windows.net/${azurerm_storage_container.acquirer_conf.name}/"
        }
      )
    }
  ]
}
