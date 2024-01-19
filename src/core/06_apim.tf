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
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# API Manager.
# ------------------------------------------------------------------------------
resource "azurerm_api_management" "mil" {
  name                 = "${local.project}-apim"
  resource_group_name  = azurerm_resource_group.integration.name
  location             = azurerm_resource_group.integration.location
  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name             = var.apim_sku
  virtual_network_type = "External"
  tags                 = var.tags

  identity {
    type = "SystemAssigned"
  }

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }

  lifecycle {
    ignore_changes = [
      sku_name
    ]
  }
}

# ------------------------------------------------------------------------------
# APIM logger.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_logger" "mil" {
  name                = "${local.project}-apim-logger"
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_resource_group.integration.name

  application_insights {
    instrumentation_key = azurerm_application_insights.mil.instrumentation_key
  }
}

# ------------------------------------------------------------------------------
# APIM diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_diagnostic" "mil" {
  identifier                = "applicationinsights"
  resource_group_name       = azurerm_resource_group.integration.name
  api_management_name       = azurerm_api_management.mil.name
  api_management_logger_id  = azurerm_api_management_logger.mil.id
  sampling_percentage       = 5
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "error"
  http_correlation_protocol = "W3C"
}

# ------------------------------------------------------------------------------
# Subscription for tracing.
# For DEV and UAT only.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_subscription" "tracing" {
  count               = var.env_short == "p" ? 0 : 1
  api_management_name = azurerm_api_management.mil.name
  resource_group_name = azurerm_api_management.mil.resource_group_name
  display_name        = "Tracing"
  state               = "active"
  allow_tracing       = true
}