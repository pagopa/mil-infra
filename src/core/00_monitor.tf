# ==============================================================================
# This file contains stuff needed to setup the monitoring infrastructure.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "log_analytics_workspace" {
  type = object({
    sku               = string
    retention_in_days = number
    daily_quota_gb    = number
  })
  description = "Log Analytics Workspace variables"
  default = {
    sku               = "PerGB2018"
    retention_in_days = 30
    daily_quota_gb    = 1
  }
}

# ------------------------------------------------------------------------------
# Workspace.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  sku                 = var.log_analytics_workspace.sku
  retention_in_days   = var.log_analytics_workspace.retention_in_days
  daily_quota_gb      = var.log_analytics_workspace.daily_quota_gb
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      sku
    ]
  }
}

# ------------------------------------------------------------------------------
# Application insights.
# ------------------------------------------------------------------------------
resource "azurerm_application_insights" "mil" {
  name                       = "${local.project}-appi"
  location                   = azurerm_resource_group.monitor.location
  resource_group_name        = azurerm_resource_group.monitor.name
  workspace_id               = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type           = "other"
  tags                       = var.tags
  internet_ingestion_enabled = true
  internet_query_enabled     = true
}

# ------------------------------------------------------------------------------
# Storing Application Insights connection strings in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "application_insigths_mil_connection_string" {
  name         = "application-insigths-mil-connection-string"
  value        = azurerm_application_insights.mil.connection_string
  key_vault_id = azurerm_key_vault.general.id
}

# ------------------------------------------------------------------------------
# Query pack.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack" "query_pack" {
  name                = "${local.project}-pack"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Query for failed requestes.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "failed_requestes" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "requests | where success == false | project timestamp, name, resultCode | take 100"
  display_name  = "*** failed requestes ***"
}

# ------------------------------------------------------------------------------
# Query to count WARN/ERROR/FATAL of MIL modules in the last hour.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "mil_errors_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where time_t > ago(60m) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | where log_level == 'WARN' or log_level == 'ERROR' or log_level == 'FATAL' | summarize WARNs = count() by ContainerName_s, log_level"
  display_name  = "*** mil - number of errors in the last hour ***"
}
