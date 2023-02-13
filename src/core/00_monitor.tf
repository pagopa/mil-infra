resource "azurerm_resource_group" "monitor" {
  name     = "${local.project}-monitor-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  sku                 = var.log_analytics_workspace.sku
  retention_in_days   = var.log_analytics_workspace.retention_in_days
  daily_quota_gb      = var.log_analytics_workspace.daily_quota_gb

  tags = var.tags
}

resource "azurerm_log_analytics_query_pack" "query_pack" {
  name                = "${local.project}-pack"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  tags                = var.tags
}

resource "azurerm_log_analytics_query_pack_query" "mil_functions_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-functions' | project time_s, Stream_s, Log_s | take 100"
  display_name  = "mil-functions - container app console logs"
}

resource "azurerm_log_analytics_query_pack_query" "mil_payment_notice_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-payment-notice' | project time_s, Stream_s, Log_s | take 100"
  display_name  = "mil-payment-notice - container app console logs"
}

resource "azurerm_log_analytics_query_pack_query" "mil_fee_calculator_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-fee-calculator' | project time_s, Stream_s, Log_s | take 100"
  display_name  = "mil-fee-calculator - container app console logs"
}