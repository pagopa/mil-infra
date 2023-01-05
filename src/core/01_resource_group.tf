# Resource group for network-related stuff.
resource "azurerm_resource_group" "network_rg" {
  name     = "${local.project}-network-rg"
  location = var.location
  tags     = var.tags
}

# Resource group for security-related stuff.
resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = var.location
  tags     = var.tags
}

# Resource group for data-related stuff.
resource "azurerm_resource_group" "data_rg" {
  name     = "${local.project}-data-rg"
  location = var.location
  tags     = var.tags
}

# Resource group for app-related stuff.
resource "azurerm_resource_group" "app_rg" {
  name     = "${local.project}-app-rg"
  location = var.location
  tags     = var.tags
}

# Resource group for integration-related stuff.
resource "azurerm_resource_group" "integration_rg" {
  name     = "${local.project}-integration-rg"
  location = var.location
  tags     = var.tags
}

# Resource group for dmz-related stuff.
resource "azurerm_resource_group" "dmz_rg" {
  name     = "${local.project}-dmz-rg"
  location = var.location
  tags     = var.tags
}