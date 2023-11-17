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
resource "azurerm_subnet" "dns_forwarder_snet" {
  name                                          = "${local.project}-dnsforwarder-snet"
  resource_group_name                           = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.intern.name
  address_prefixes                              = [var.dnsforwarder_snet_cidr]
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = false

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# ------------------------------------------------------------------------------
# Private DNS for private endpoint from APP SUBNET (containing Container Apps)
# to the key vaultd.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "key_vault" {
  count               = (var.mil_auth_armored_key_vault || var.mil_idpay_armored_key_vault) ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  count                 = (var.mil_auth_armored_key_vault || var.mil_idpay_armored_key_vault) ? 1 : 0
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

# ------------------------------------------------------------------------------
# Private DNS for private endpoint from APP SUBNET (containing Container Apps)
# to the storage account.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "storage" {
  count               = (var.armored_storage_account_for_acquirers_conf || var.mil_auth_armored_storage_account) ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  count                 = (var.armored_storage_account_for_acquirers_conf || var.mil_auth_armored_storage_account) ? 1 : 0
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.storage[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}