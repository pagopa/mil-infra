#
# API for mil-acquirer-conf
#
module "mock_nodo_api" {
  count               = var.env_short == "d" ? 1 : 0
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-mock-nodo"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Handling the configuration for mock Soap and Rest responses"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v1"

  # The Path for this API Management API, which is a relative URL which uniquely identifies this API and all of its resource paths within the API Management Service.
  path = "mockNodo"

  display_name = "MockNodo"
  #content_format        = "openapi-link"
  #content_value         = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/acquirer-conf.yaml"
  content_format        = "openapi"
  content_value         = file("${path.module}/mock-nodo/mock-nodo-openapi.yaml")
  product_ids           = [module.mil_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "mockSoap"
      xml_content  = templatefile("policies/mil-mock-nodo-soap.xml", { storage_account_name = "${azurerm_storage_account.mock[0].name}" })
    },
    {
      operation_id = "mockRest"
      xml_content  = templatefile("policies/mil-mock-nodo-rest.xml", { storage_account_name = "${azurerm_storage_account.mock[0].name}" })
    }
  ]


}
