# ==============================================================================
# This file contains stuff needed to setup the VPN.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "vpn_sku" {
  type = string
}

variable "vpn_pip_sku" {
  type = string
}

variable "vpn_client_address_space" {
  type = string
}

# ------------------------------------------------------------------------------
# VPN.
# ------------------------------------------------------------------------------
data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

resource "random_string" "dns" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_public_ip" "vpn" {
  name                = "${local.project}-vpn-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${lower(replace(local.project, "/[[:^alnum:]]/", ""))}vpn${random_string.dns.result}"
  sku                 = var.vpn_pip_sku
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "${local.project}-vpn-gw"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = var.vpn_sku
  tags                = var.tags

  ip_configuration {
    name                          = "${local.project}-vpn-gw-config"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn.id
  }

  vpn_client_configuration {
    aad_audience         = data.azuread_application.vpn_app.client_id
    aad_issuer           = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
    aad_tenant           = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
    address_space        = [var.vpn_client_address_space]
    vpn_client_protocols = ["OpenVPN"]
  }
}

# ------------------------------------------------------------------------------
# DNS forwarder.
# ------------------------------------------------------------------------------
resource "azurerm_container_group" "vpn_dns_forwarder" {
  name                = "${local.project}-vpn-dnsfrw"
  location            = var.location
  resource_group_name = azurerm_virtual_network.intern.resource_group_name
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.dns_forwarder_snet.id]
  os_type             = "Linux"
  tags                = var.tags

  container {
    name = "dns-forwarder"
    # from https://hub.docker.com/r/coredns/coredns
    image    = "coredns/coredns:1.10.1@sha256:be7652ce0b43b1339f3d14d9b14af9f588578011092c1f7893bd55432d83a378"
    cpu      = "0.5"
    memory   = "0.5"
    commands = ["/coredns", "-conf", "/app/conf/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    volume {
      mount_path = "/app/conf"
      name       = "dns-forwarder-conf"
      read_only  = true
      secret = {
        Corefile = base64encode(
          <<EOT
          .:53 {
            errors
            ready
            health
            forward . 168.63.129.16
            cache 30
            loop
            reload
          }
          EOT
        )
      }
    }
  }
}