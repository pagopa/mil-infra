# Product.
module "mil_product__external__oauth" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v5.1.0"
  product_id            = "mil-external-oauth"
  display_name          = "MIL - External APIs - OAuth"
  description           = "Multi-channel Integration Layer for SW Client Project - External APIs - OAuth"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = false
  approval_required     = false
}