# ------------------------------------------------------------------------------
# Container Apps Environment.
# ------------------------------------------------------------------------------
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
