# Virtual network.
resource "azurerm_virtual_network" "mil" {
  name                = "${local.project}-vnet"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags

  # Subnet for App Gateway.
  subnet {
    name           = "${local.project}-dmz-snet"
    address_prefix = "10.1.0.0/20"
  }

  # Subnet for API Manager.
  subnet {
    name           = "${local.project}-integration-snet"
    address_prefix = "10.1.16.0/20"
  }

  # Subnet for Container Apps.
  subnet {
    name           = "${local.project}-app-snet"
    address_prefix = "10.1.32.0/20"
  }

  # Subnet for data-related stuff.
  subnet {
    name           = "${local.project}-data-snet"
    address_prefix = "10.1.48.0/20"
  }
}
