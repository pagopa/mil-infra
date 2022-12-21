# Key vault.
module "key_vault" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v3.2.0"
  name                = "${local.project}-kv"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  tags                = var.tags
}