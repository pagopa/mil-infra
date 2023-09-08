#
# Redis Cache
#

#
# PRIVATE ENDPOINT APP SUBNET -> REDIS
#
resource "azurerm_private_dns_zone" "redis" {
  count               = var.env_short == "d" ? 0 : 1
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  count                 = var.env_short == "d" ? 0 : 1
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.redis[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

#
# Redis Cache proper
#
module "redis_cache" {
  source                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v6.20.0"
  name                          = "${local.project}-redis"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  capacity                      = 1
  enable_non_ssl_port           = false
  family                        = "C"
  sku_name                      = "Basic"
  enable_authentication         = true
  public_network_access_enabled = var.env_short == "d" ? true : false
  redis_version                 = 6
  zones                         = null

  private_endpoint = {
    enabled              = var.env_short == "d" ? false : true
    virtual_network_id   = var.env_short == "d" ? "dontcare" : azurerm_private_dns_zone_virtual_network_link.redis[0].virtual_network_id
    subnet_id            = azurerm_subnet.app.id
    private_dns_zone_ids = [var.env_short == "d" ? "dontcare" : azurerm_private_dns_zone.redis[0].id]
  }

  tags = var.tags
}