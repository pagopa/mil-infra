#
# Resource group for network-related stuff
#
resource "azurerm_resource_group" "network" {
  name     = "${local.project}-network-rg"
  location = var.location
  tags     = var.tags
}

#
# Resource group for security-related stuff
#
resource "azurerm_resource_group" "sec" {
  name     = "${local.project}-sec-rg"
  location = var.location
  tags     = var.tags
}

#
# Resource group for data-related stuff
#
resource "azurerm_resource_group" "data" {
  name     = "${local.project}-data-rg"
  location = var.location
  tags     = var.tags
}

#
# Resource group for app-related stuff
#
resource "azurerm_resource_group" "app" {
  name     = "${local.project}-app-rg"
  location = var.location
  tags     = var.tags
}

#
# Resource group for integration-related stuff
#
resource "azurerm_resource_group" "integration" {
  name     = "${local.project}-integration-rg"
  location = var.location
  tags     = var.tags
}