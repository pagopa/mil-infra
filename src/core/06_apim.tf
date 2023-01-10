# Publisher e-mail will be picked from key-vault.
data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = module.key_vault.id
}

# API Manager.
module "apim" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v3.4.5"
  name                 = "${local.project}-apim"
  resource_group_name  = azurerm_resource_group.integration.name
  location             = azurerm_resource_group.integration.location
  subnet_id            = azurerm_subnet.apim.id
  sku_name             = var.apim_sku
  virtual_network_type = "External"
  sign_up_enabled      = false
  lock_enable          = false
  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  redis_cache_id       = null
  tags                 = var.tags
}