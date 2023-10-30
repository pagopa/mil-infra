#
# GitHub runner
#
resource "azurerm_resource_group" "github_runner" {
  name     = "${local.project}-github-runner-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_subnet" "github_runner" {
  name                 = "${local.project}-github-runner-snet"
  resource_group_name  = azurerm_virtual_network.intern.resource_group_name
  virtual_network_name = azurerm_virtual_network.intern.name
  address_prefixes     = [var.github_runner_cidr]
}

module "github_runner" {
  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment?ref=v7.14.0"
  name                      = "${local.project}-github-runner-cae"
  resource_group_name       = azurerm_resource_group.github_runner.name
  location                  = var.location
  vnet_internal             = true
  subnet_id                 = azurerm_subnet.github_runner.id
  log_destination           = "log-analytics"
  log_analytics_customer_id = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
  log_analytics_shared_key  = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  zone_redundant            = false
  tags                      = var.tags
}
