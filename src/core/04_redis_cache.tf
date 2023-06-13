#
# Redis Cache
#
module "redis_cache" {
  source                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v5.1.0"
  name                          = "${local.project}-redis"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  capacity                      = 2
  enable_non_ssl_port           = false
  family                        = "C"
  sku_name                      = "Basic"
  enable_authentication         = true
  public_network_access_enabled = true

  private_endpoint = {
    enabled              = false
    virtual_network_id   = ""
    subnet_id            = ""
    private_dns_zone_ids = []
  }

  tags = var.tags
}