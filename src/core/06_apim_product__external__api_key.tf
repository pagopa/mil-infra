# Product.
module "mil_product__external__api_key" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v5.1.0"
  product_id            = "mil-external-api-key"
  display_name          = "MIL - External APIs - API Key"
  description           = "Multi-channel Integration Layer for SW Client Project - External APIs - API Key"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = true
  approval_required     = false
}

