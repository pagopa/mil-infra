# Container Apps Environment.
module "cae" {
  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment?ref=v4.1.12"
  name                      = "${local.project}-cae"
  resource_group_name       = azurerm_resource_group.app.name
  location                  = azurerm_resource_group.app.location
  vnet_internal             = false
  subnet_id                 = azurerm_subnet.app.id
  log_destination           = "log-analytics"
  log_analytics_customer_id = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
  log_analytics_shared_key  = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  zone_redundant            = false
  tags                      = var.tags
}
