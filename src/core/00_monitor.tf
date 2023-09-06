#
# Resource group for monitor stuff
#
resource "azurerm_resource_group" "monitor" {
  name     = "${local.project}-monitor-rg"
  location = var.location
  tags     = var.tags
}

#
# Workspace
#
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.project}-law"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  sku                 = var.log_analytics_workspace.sku
  retention_in_days   = var.log_analytics_workspace.retention_in_days
  daily_quota_gb      = var.log_analytics_workspace.daily_quota_gb
  tags                = var.tags
}

#
# Application insight
#
resource "azurerm_application_insights" "mil" {
  name                = "${local.project}-appi"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "other"
}

#
# Query pack
#
resource "azurerm_log_analytics_query_pack" "query_pack" {
  name                = "${local.project}-pack"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  tags                = var.tags
}

#
# Query for mil-functions stdout/stdin
#
#resource "azurerm_log_analytics_query_pack_query" "mil_functions_container_app_console_logs" {
#  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
#  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-functions' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
#  display_name  = "mil-functions - last hour logs"
#}

#
# Query for mil-payment-notice stdout/stdin
#
resource "azurerm_log_analytics_query_pack_query" "mil_payment_notice_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-payment-notice' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "mil-payment-notice - last hour logs"
}

#
# Query for mil-fee-calculator stdout/stdin
#
resource "azurerm_log_analytics_query_pack_query" "mil_fee_calculator_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-fee-calculator' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "mil-fee-calculator - last hour logs"
}

#
# Query for failed requestes - Does it work?
#
resource "azurerm_log_analytics_query_pack_query" "failed_requestes" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "requests | where success == false | project timestamp, name, resultCode | take 100"
  display_name  = "failed requestes"
}

#
# Query for mil-auth stdout/stdin
#
resource "azurerm_log_analytics_query_pack_query" "mil_auth_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-auth' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "mil-auth - last hour logs"
}

#
# Query for mil-preset stdout/stdin
#
resource "azurerm_log_analytics_query_pack_query" "mil_preset_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-preset' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "mil-preset - last hour logs"
}

#
# Query for mil-idpay stdout/stdin
#
resource "azurerm_log_analytics_query_pack_query" "mil_idpay_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-idpay' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "mil-idpay - last hour logs"
}

#
# Query to count WARN/ERROR/FATAL of MIL modules in the last hour
#
resource "azurerm_log_analytics_query_pack_query" "mil_errors_container_app_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where time_t > ago(60m) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | where log_level == 'WARN' or log_level == 'ERROR' or log_level == 'FATAL' | summarize WARNs = count() by ContainerName_s, log_level"
  display_name  = "mil - number of errors in the last hour"
}