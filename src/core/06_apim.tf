# ==============================================================================
# This file contains stuff needed to setup the API Manager.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "apim_sku" {
  type        = string
  description = "String made up of two components separated by an underscore: the 1st component is the name (Consumption, Developer, Basic, Standard, Premium); the 2nd component is the capacity (it must be an integer greater than 0)."
}

variable "apim_publisher_name" {
  type        = string
  description = "The name of the publisher."
  default     = "PagoPA S.p.A."
}

# ------------------------------------------------------------------------------
# Publisher e-mail will be taken from key-vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# API Manager.
# ------------------------------------------------------------------------------
module "apim" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v7.14.0"
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

# ------------------------------------------------------------------------------
# Subscription for tracing.
# For DEV and UAT only.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_subscription" "tracing" {
  count               = var.env_short == "p" ? 0 : 1
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  display_name        = "Tracing"
  state               = "active"
  allow_tracing       = true
}