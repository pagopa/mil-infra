#
# Main virtual network
#
resource "azurerm_virtual_network" "intern" {
  name                = "${local.project}-intern-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.intern_vnet_cidr]
  tags                = var.tags
}

#
# Subnet for Application Gateway
#
resource "azurerm_subnet" "appgw" {
  name                 = "${local.project}-agw-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.appgw_snet_cidr]
}

#
# Subnet for Container Apps
#
resource "azurerm_subnet" "app" {
  name                 = "${local.project}-app-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.app_snet_cidr]
}

#
# Subnet for data-related stuff
#
resource "azurerm_subnet" "data" {
  name                 = "${local.project}-data-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.data_snet_cidr]
}

#
# Subnet for VPN
#
resource "azurerm_subnet" "vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.vpn_snet_cidr]
}

#
# Virtual network for integration dedicated to API Manager
#
resource "azurerm_virtual_network" "integr" {
  name                = "${local.project}-integr-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.integr_vnet_cidr]
  tags                = var.tags
}

#
# Subnet for API Manager
#
resource "azurerm_subnet" "apim" {
  name                 = "${local.project}-apim-snet"
  resource_group_name  = azurerm_virtual_network.integr.resource_group_name
  virtual_network_name = azurerm_virtual_network.integr.name
  address_prefixes     = [var.apim_snet_cidr]
}

#
# VPN
#
data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

module "vpn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway?ref=v7.14.0"

  name                = "${local.project}-intern-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  sku                 = var.vpn_sku
  pip_sku             = var.vpn_pip_sku
  subnet_id           = azurerm_subnet.vpn.id

  #log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  #log_storage_account_id     = module.operations_logs.id

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.application_id
      aad_issuer            = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
      aad_tenant            = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}