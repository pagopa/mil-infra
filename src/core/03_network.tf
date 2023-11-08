# ==============================================================================
# This file contains stuff needed to setup the network.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "integr_vnet_cidr" {
  type        = string
  description = "Integration Virtual Network CIDR."
}

variable "apim_snet_cidr" {
  type        = string
  description = "API Manager Subnet CIDR."
}

variable "intern_vnet_cidr" {
  type        = string
  description = "Internal Virtual Network CIDR."
}

variable "appgw_snet_cidr" {
  type        = string
  description = "App GW Subnet CIDR."
}

variable "data_snet_cidr" {
  type        = string
  description = "Data Subnet CIDR."
}

variable "app_snet_cidr" {
  type        = string
  description = "Application Subnet CIDR."
}

variable "vpn_snet_cidr" {
  type        = string
  description = "VPN Subnet CIDR."
}

variable "dnsforwarder_snet_cidr" {
  type        = string
  description = "DNS Forwarder Subnet CIDR."
}

# ------------------------------------------------------------------------------
# Main virtual network.
# ------------------------------------------------------------------------------
resource "azurerm_virtual_network" "intern" {
  name                = "${local.project}-intern-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.intern_vnet_cidr]
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Subnet for Application Gateway.
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "appgw" {
  name                 = "${local.project}-agw-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.appgw_snet_cidr]
}

# ------------------------------------------------------------------------------
# Subnet for Container Apps.
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "app" {
  name                 = "${local.project}-app-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.app_snet_cidr]
}

# ------------------------------------------------------------------------------
# Subnet for data-related stuff.
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "data" {
  name                 = "${local.project}-data-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.data_snet_cidr]
}

# ------------------------------------------------------------------------------
# Subnet for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.vpn_snet_cidr]
}

# ------------------------------------------------------------------------------
# Virtual network for integration dedicated to API Manager.
# ------------------------------------------------------------------------------
resource "azurerm_virtual_network" "integr" {
  name                = "${local.project}-integr-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.integr_vnet_cidr]
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Subnet for API Manager.
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "apim" {
  name                 = "${local.project}-apim-snet"
  resource_group_name  = azurerm_virtual_network.integr.resource_group_name
  virtual_network_name = azurerm_virtual_network.integr.name
  address_prefixes     = [var.apim_snet_cidr]
}

# ------------------------------------------------------------------------------
# Subnet for DNS forwarder.
# ------------------------------------------------------------------------------
module "dns_forwarder_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.14.0"
  name                                      = "${local.project}-dnsforwarder-snet"
  resource_group_name                       = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.intern.name
  address_prefixes                          = [var.dnsforwarder_snet_cidr]
  private_endpoint_network_policies_enabled = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}