terraform {
  required_version = "= 1.3.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.53.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.39.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}