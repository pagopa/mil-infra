#
# Product for Nodo mock
#
module "mock_nodo" {
  count                 = var.env_short == "d" ? 1 : 0
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v5.1.0"
  product_id            = "mock-nodo"
  display_name          = "mock-nodo"
  description           = "mock-nodo"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = true
  approval_required     = false
}