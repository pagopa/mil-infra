# ------------------------------------------------------------------------------
# General purpose key vault used to protect secrets.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "general" {
  name                          = "${local.project}-general-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  public_network_access_enabled = true
  tags                          = var.tags
}