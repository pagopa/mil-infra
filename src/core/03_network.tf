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
# to the key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

# ------------------------------------------------------------------------------
# Private DNS for private endpoint from APP SUBNET (containing Container Apps)
# to the storage account.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

# ------------------------------------------------------------------------------
# Network security group for APIM.
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "apim" {
  name                = "${local.project}-apim-nsg"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  security_rule {
    name                       = "Internet-VirtualNetwork"
    priority                   = 100
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "443"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "ApiManagement-VirtualNetwork"
    priority                   = 101
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "3443"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AzureLoadBalancer-VirtualNetwork"
    priority                   = 102
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "6390"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AzureTrafficManager-VirtualNetwork"
    priority                   = 103
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "443"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureTrafficManager"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "VirtualNetwork-Storage"
    priority                   = 104
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "443"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "VirtualNetwork-SQL"
    priority                   = 105
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "1443"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "SQL"
  }

  security_rule {
    name                       = "VirtualNetwork-AzureKeyVault"
    priority                   = 106
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "443"
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }

  security_rule {
    name                       = "VirtualNetwork-AzureMonitor"
    priority                   = 107
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_ranges    = ["1886", "443"]
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureMonitor"
  }
}

resource "azurerm_subnet_network_security_group_association" "apim" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.apim.id
}

#
# Peering
#
resource "azurerm_virtual_network_peering" "intern_integr" {
  name                      = "intern_2_integr"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.intern.name
  remote_virtual_network_id = azurerm_virtual_network.integr.id
}

resource "azurerm_virtual_network_peering" "integr_intern" {
  name                      = "integr_2_intern"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.integr.name
  remote_virtual_network_id = azurerm_virtual_network.intern.id
}
