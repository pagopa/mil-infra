# ------------------------------------------------------------------------------
# Container Apps Environment.
# ------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "mil" {
  name                           = "${local.project}-cae"
  location                       = azurerm_resource_group.app.location
  resource_group_name            = azurerm_resource_group.app.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id
  internal_load_balancer_enabled = false # true
  infrastructure_subnet_id       = azurerm_subnet.app.id
  tags                           = var.tags
  zone_redundancy_enabled        = false
}

# ------------------------------------------------------------------------------
# Private DNS to resolve Container Apps IP.
# ------------------------------------------------------------------------------
#resource "azurerm_private_dns_zone" "mil_cae" {
#  name                = azurerm_container_app_environment.mil.default_domain
#  resource_group_name = azurerm_resource_group.network.name
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "mil_cae" {
#  name                  = azurerm_virtual_network.intern.name
#  resource_group_name   = azurerm_resource_group.network.name
#  private_dns_zone_name = azurerm_private_dns_zone.mil_cae.name
#  virtual_network_id    = azurerm_virtual_network.intern.id
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "apim" {
#  name                  = azurerm_virtual_network.integr.name
#  resource_group_name   = azurerm_resource_group.network.name
#  private_dns_zone_name = azurerm_private_dns_zone.mil_cae.name
#  virtual_network_id    = azurerm_virtual_network.integr.id
#}

#resource "azurerm_private_dns_a_record" "mil_cae" {
#  name                = "*"
#  zone_name           = azurerm_private_dns_zone.mil_cae.name
#  resource_group_name = azurerm_resource_group.network.name
#  ttl                 = 300
#  records             = [azurerm_container_app_environment.mil.static_ip_address]
#}

