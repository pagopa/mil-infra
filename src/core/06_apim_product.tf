# ------------------------------------------------------------------------------
# Product.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_product" "mil" {
  resource_group_name   = azurerm_api_management.mil.resource_group_name
  product_id            = "mil"
  api_management_name   = azurerm_api_management.mil.name
  display_name          = "Multi-channel Integration Layer"
  description           = "Multi-channel Integration Layer"
  subscription_required = false
  published             = true
}
