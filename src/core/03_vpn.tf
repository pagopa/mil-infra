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

# ------------------------------------------------------------------------------
# VPN.
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# DNS forwarder.
# ------------------------------------------------------------------------------
module "vpn_dns_forwarder" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder?ref=v7.14.0"
  name                = "${local.project}-vpn-dnsfrw"
  location            = var.location
  resource_group_name = azurerm_virtual_network.intern.resource_group_name
  subnet_id           = module.dns_forwarder_snet.id
  tags                = var.tags
}