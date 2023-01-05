## user assined identity: (application gateway) ##
resource "azurerm_user_assigned_identity" "appgateway" {
  resource_group_name = azurerm_resource_group.dmz_rg.name
  location            = azurerm_resource_group.dmz_rg.location
  name                = "${local.project}-appgateway-identity"
  tags                = var.tags
}

## Application gateway public ip ##
## TODO: VERIFICARE CHE SIA MULTI-ZONE
resource "azurerm_public_ip" "appgateway" {
  name                = "${local.project}-appgateway-pip"
  resource_group_name = azurerm_resource_group.dmz_rg.name
  location            = azurerm_resource_group.dmz_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}
