# Product.
locals {
  product_id = "mil"
}

module "mil_product" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v4.1.12"
  product_id            = local.product_id
  display_name          = "Multi-channel Integration Layer"
  description           = "Multi-channel Integration Layer for SW Client Project"
  api_management_name   = module.apim.name
  resource_group_name   = module.apim.resource_group_name
  published             = true
  subscription_required = false
  approval_required     = false
}

# Subscription for tracing. For DEV only.
resource "azurerm_api_management_subscription" "tracing" {
  count               = var.env_short == "d" ? 1 : 0
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  display_name        = "Tracing"
  state               = "active"
  allow_tracing       = true
}