# ------------------------------------------------------------------------------
# Container Apps Environment.
# ------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "mil" {
  name                           = "${local.project}-cae"
  location                       = azurerm_resource_group.app.location
  resource_group_name            = azurerm_resource_group.app.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id
  internal_load_balancer_enabled = false # true
  infrastructure_subnet_id       = azurerm_subnet.app.id
  tags                           = var.tags
  zone_redundancy_enabled        = false
}

# ------------------------------------------------------------------------------
# Network security grop for ACA.
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "cae" {
  name                = "${local.project}-cae-nsg"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  security_rule {
    name                       = "allow-apim-to-aca"
    priority                   = 100
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    protocol                   = "*"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "cae" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.cae.id
}