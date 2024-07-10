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

# ------------------------------------------------------------------------------
# CORS Policy.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_product_policy" "cors" {
  count               = 0 #var.env_short == "d" ? 1 : 0
  product_id          = azurerm_api_management_product.mil.product_id
  api_management_name = azurerm_api_management_product.mil.api_management_name
  resource_group_name = azurerm_api_management_product.mil.resource_group_name
  xml_content = <<XML
    <policies>
      <inbound>
        <cors allow-credentials="false">
          <allowed-origins>
            <origin>*</origin>
          </allowed-origins>
          <allowed-methods>
            <method>GET</method>
            <method>POST</method>
          </allowed-methods>
        </cors>
      </inbound>
      <backend>
        <forward-request />
      </backend>
      <outbound />
      <on-error />
    </policies>
  XML
}