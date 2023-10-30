#
# Key vault
#
module "key_vault" {
  source                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v7.14.0"
  name                      = "${local.project}-kv"
  location                  = azurerm_resource_group.sec.location
  resource_group_name       = azurerm_resource_group.sec.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "premium"
  enable_rbac_authorization = true
  tags                      = var.tags
}

resource "azurerm_key_vault" "appl_key_vault" {
  name                          = "${local.project}-appl-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  sku_name                      = "premium"
  public_network_access_enabled = var.env_short == "d" ? true : false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Rotate",
      "Encrypt",
      "Decrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
      "Release"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azuread_service_principal.mil_services.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Rotate",
      "Encrypt",
      "Decrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
      "Release"
    ]

    secret_permissions = []

    certificate_permissions = []
  }
}

resource "azurerm_key_vault" "auth_key_vault" {
  name                          = "${local.project}-auth-kv"
  location                      = azurerm_resource_group.sec.location
  resource_group_name           = azurerm_resource_group.sec.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  purge_protection_enabled      = true
  sku_name                      = "premium"
  public_network_access_enabled = var.env_short == "d" ? true : false
  enable_rbac_authorization     = true
}

#
# PRIVATE ENDPOINT APP SUBNET -> KEY VAULT
#
resource "azurerm_private_dns_zone" "keyvault" {
  count               = var.env_short == "d" ? 0 : 1
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count                 = var.env_short == "d" ? 0 : 1
  name                  = azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  virtual_network_id    = azurerm_virtual_network.intern.id
}

resource "azurerm_private_endpoint" "keyvault_pep" {
  count               = var.env_short == "d" ? 0 : 1
  name                = "${local.project}-keyvault-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.app.id

  custom_network_interface_name = "${local.project}-keyvault-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-keyvault-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault[0].id]
  }

  private_service_connection {
    name                           = "${local.project}-keyvault-psc"
    private_connection_resource_id = azurerm_key_vault.appl_key_vault.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}
