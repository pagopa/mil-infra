#
# Publisher e-mail will be taken from key-vault
#
data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = module.key_vault.id
}

#
# API Manager
#
module "apim" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v6.20.0"
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
  application_insights = {
    enabled             = true
    instrumentation_key = azurerm_application_insights.mil.instrumentation_key
  }
  tags = var.tags
}

#
# Subscription for tracing. For DEV only.
#
resource "azurerm_api_management_subscription" "tracing" {
  count               = (var.env_short == "d" || var.env_short == "u") ? 1 : 0
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  display_name        = "Tracing"
  state               = "active"
  allow_tracing       = true
}

resource "azurerm_role_assignment" "apim_id__to__conf_storage_account" {
  scope                = azurerm_storage_account.conf.id
  role_definition_name = "Contributor"
  principal_id         = module.apim.principal_id
}