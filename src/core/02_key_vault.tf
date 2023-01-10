# Key vault.
module "key_vault" {
  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v3.5.1"
  name                      = "${local.project}-kv"
  location                  = azurerm_resource_group.sec.location
  resource_group_name       = azurerm_resource_group.sec.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "premium"
  enable_rbac_authorization = true
  tags                      = var.tags
}

