# Redis Cache.
module "redis_cache" {
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v4.1.11"
  name                  = "${local.project}-redis"
  resource_group_name   = azurerm_resource_group.data.name
  location              = azurerm_resource_group.data.location
  capacity              = 1
  enable_non_ssl_port   = false
  family                = "C"
  sku_name              = "Basic"
  enable_authentication = true
  tags                  = var.tags
}