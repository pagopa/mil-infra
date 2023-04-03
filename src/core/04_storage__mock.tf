resource "azurerm_storage_account" "mock" {
  count                    = var.env_short == "d" ? 1 : 0
  name                     = "mocknodo"
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags

  #network_rules {
  #  default_action             = "Deny"
  #  virtual_network_subnet_ids = [azurerm_subnet.apim.id]
  #}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "mock" {
  count                 = var.env_short == "d" ? 1 : 0
  name                  = "mocknodo"
  storage_account_name  = azurerm_storage_account.mock[count.index].name
  container_access_type = "blob"
}

#### stubs returns KO for verify and activate ####
resource "azurerm_storage_blob" "stub_verify_ko_activate_ko" {
  #count                  = var.env_short == "d" ? 1 : 0
  for_each               = var.env_short == "d" ? toset([ "activatePaymentNotice_00000000001.xml","activatePaymentNotice_00000000002.xml","activatePaymentNotice_00000000003.xml",
                                                          "activatePaymentNotice_00000000004.xml","activatePaymentNotice_00000000005.xml","activatePaymentNotice_00000000006.xml",
                                                          "activatePaymentNotice_00000000007.xml","activatePaymentNotice_00000000008.xml","activatePaymentNotice_00000000009.xml",
                                                          "verifyPaymentNotice_00000000001.xml","verifyPaymentNotice_00000000002.xml","verifyPaymentNotice_00000000003.xml",
                                                          "verifyPaymentNotice_00000000004.xml","verifyPaymentNotice_00000000005.xml","verifyPaymentNotice_00000000006.xml",
                                                          "verifyPaymentNotice_00000000007.xml","verifyPaymentNotice_00000000008.xml","verifyPaymentNotice_00000000009.xml"
                                                          ]) : toset([])

  name                   = each.key # File name on storage container
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("",["mock-nodo/FiscalCode_0000000000x/",each.key]) # Local file name
}

#### stubs returns OK for verify and KO for activate ####
resource "azurerm_storage_blob" "stub_verify_ok_activate_ko" {
  #count                  = var.env_short == "d" ? 1 : 0
  for_each               = var.env_short == "d" ? toset([ "activatePaymentNotice_00000000101.xml","activatePaymentNotice_00000000102.xml","activatePaymentNotice_00000000103.xml",
                                                          "activatePaymentNotice_00000000104.xml","activatePaymentNotice_00000000105.xml","activatePaymentNotice_00000000106.xml",
                                                          "activatePaymentNotice_00000000107.xml","activatePaymentNotice_00000000108.xml","activatePaymentNotice_00000000109.xml",
                                                          "verifyPaymentNotice_00000000101.xml","verifyPaymentNotice_00000000102.xml","verifyPaymentNotice_00000000103.xml",
                                                          "verifyPaymentNotice_00000000104.xml","verifyPaymentNotice_00000000105.xml","verifyPaymentNotice_00000000106.xml",
                                                          "verifyPaymentNotice_00000000107.xml","verifyPaymentNotice_00000000108.xml","verifyPaymentNotice_00000000109.xml"
                                                          ]) : toset([])
  name                   = each.key # File name on storage container
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("",["mock-nodo/FiscalCode_0000000010x/",each.key]) # Local file name
}


#### stubs returns OK for verify and activate ####
resource "azurerm_storage_blob" "stub_verify_ok_activate_ok" {
  #count                  = var.env_short == "d" ? 1 : 0
  for_each               = var.env_short == "d" ? toset([ "activatePaymentNotice_00000000201.xml","activatePaymentNotice_00000000202.xml","activatePaymentNotice_00000000203.xml",
                                                          "activatePaymentNotice_00000000204.xml","activatePaymentNotice_00000000205.xml","activatePaymentNotice_00000000206.xml",
                                                          "activatePaymentNotice_00000000207.xml","activatePaymentNotice_00000000208.xml","activatePaymentNotice_00000000209.xml",
                                                          "verifyPaymentNotice_00000000201.xml","verifyPaymentNotice_00000000202.xml","verifyPaymentNotice_00000000203.xml",
                                                          "verifyPaymentNotice_00000000204.xml","verifyPaymentNotice_00000000205.xml","verifyPaymentNotice_00000000206.xml",
                                                          "verifyPaymentNotice_00000000207.xml","verifyPaymentNotice_00000000208.xml","verifyPaymentNotice_00000000209.xml",
                                                          "outcome_4e2581e0ca454011830fe8f7fbd03a85.json","outcome_37b0bb69ce774bc2bfeb485e107ae335.json","payments.json"
                                                          ]) : toset([])
  name                   = join("",["/0000000020x/",each.key]) # File name on storage container
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("",["mock-nodo/FiscalCode_0000000020x/",each.key]) # Local file name
}