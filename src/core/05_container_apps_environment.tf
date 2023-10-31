#
# Container Apps Environment
#
#module "cae" {
#  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment?ref=v7.14.0"
#  name                      = "${local.project}-cae"
#  resource_group_name       = azurerm_resource_group.app.name
#  location                  = azurerm_resource_group.app.location
#  vnet_internal             = false
#  subnet_id                 = azurerm_subnet.app.id
#  log_destination           = "log-analytics"
#  log_analytics_customer_id = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
#  log_analytics_shared_key  = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
#  zone_redundant            = false
#  tags                      = var.tags
#}

resource "azurerm_container_app_environment" "mil" {
  name                           = "${local.project}-cae"
  location                       = azurerm_resource_group.app.location
  resource_group_name            = azurerm_resource_group.app.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id
  internal_load_balancer_enabled = false
  infrastructure_subnet_id       = azurerm_subnet.app.id
  tags                           = var.tags
  # Argument not allowed with 3.71.0
  # zone_redundancy_enabled        = false
}
