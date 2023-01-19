# User assigned identity
resource "azurerm_user_assigned_identity" "appgw" {
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  name                = "${local.project}-agw-id"
  tags                = var.tags
}

# Public IP
# TODO: DOPO LA CREAZIONE, VERIFICARE CHE SIA MULTI-ZONE!!!
resource "azurerm_public_ip" "appgw" {
  name                = "${local.project}-agw-pip"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1, 2, 3]
  tags                = var.tags
}

# Application Gateway
module "app_gw" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//app_gateway?ref=v3.13.1"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  name                = "${local.project}-agw"

  # SKU
  sku_name = "Standard_v2"
  sku_tier = "Standard_v2"

  #
  zones = [1, 2, 3]

  # TODO: DEVONO ESSERE DELLE VARIABILI
  app_gateway_min_capacity = 1
  app_gateway_max_capacity = 2

  # Networking
  subnet_id    = azurerm_subnet.appgw.id
  public_ip_id = azurerm_public_ip.appgw.id

  # Backends
  backends = {
    apim = {
      protocol                    = "Https"
      host                        = module.apim.gateway_hostname
      port                        = 443
      ip_addresses                = null # with null value use fqdns
      fqdns                       = [module.apim.gateway_hostname]
      probe                       = "/status-0123456789abcdef"
      probe_name                  = "probe-apim"
      request_timeout             = 30
      pick_host_name_from_backend = false
    }
  }

  # Listeners
  listeners = {
    api = {
      protocol           = "Https"
      host               = "api.${var.dns_zone_mil_prefix}.${var.dns_external_domain}"
      port               = 443
      firewall_policy_id = null
      certificate = {
        id   = "https://mil-d-kv.vault.azure.net/secrets/api-dev-mil/1222fdad21f346cfb39e2514a4b68add"
        name = "api-dev-mil"
      }
      ssl_profile_name = null
    }
  }

  # Maps listener-to-backend
  routes = {
    api = {
      listener              = "api"
      backend               = "apim"
      rewrite_rule_set_name = null
    }
  }

  #rewrite_rule_sets = []

  trusted_client_certificates = []
  identity_ids                = [azurerm_user_assigned_identity.appgw.id]

  tags = var.tags
}
