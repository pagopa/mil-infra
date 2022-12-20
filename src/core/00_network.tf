resource "azurerm_resource_group" "network_rg" {
  name     = "${local.project}-network-rg"
  location = var.location

  tags = var.tags
}