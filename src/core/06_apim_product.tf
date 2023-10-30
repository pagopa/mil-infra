#
# Product
#
module "mil_product" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v7.14.0"
  product_id            = "mil"
  display_name          = "Multi-channel Integration Layer"
  description           = "Multi-channel Integration Layer for SW Client Project"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = false
  approval_required     = false
}