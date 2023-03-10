# Product.
module "mil_product__internal" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v5.1.0"
  product_id            = "mil-internal"
  display_name          = "MIL - Internal APIs"
  description           = "Multi-channel Integration Layer for SW Client Project - Internal APIs"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = true
  approval_required     = false
}