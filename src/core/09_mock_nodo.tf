# ==============================================================================
# This file contains stuff needed to run the mock of the Nodo.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "install_nodo_mock" {
  description = "If true the mock of the Nodo and GEC will be installed."
  type        = bool
  default     = false
}

variable "mock_nodo_path" {
  type    = string
  default = "mockNodo"
}

# ------------------------------------------------------------------------------
# Storage account containing response files.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "mock" {
  count                    = var.install_nodo_mock ? 1 : 0
  name                     = "${var.prefix}${var.env_short}mocknodost"
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

# ------------------------------------------------------------------------------
# Storage container containing response files.
# ------------------------------------------------------------------------------
resource "azurerm_storage_container" "mock" {
  count                 = var.install_nodo_mock ? 1 : 0
  name                  = "mocknodo"
  storage_account_name  = azurerm_storage_account.mock[count.index].name
  container_access_type = "blob"
}

# ------------------------------------------------------------------------------
# Uploading of KO responses for verify and activate operations.
# ------------------------------------------------------------------------------
resource "azurerm_storage_blob" "stub_verify_ko_activate_ko" {
  for_each = var.install_nodo_mock ? toset([
    "activatePaymentNotice_00000000001.xml",
    "activatePaymentNotice_00000000002.xml",
    "activatePaymentNotice_00000000003.xml",
    "activatePaymentNotice_00000000004.xml",
    "activatePaymentNotice_00000000005.xml",
    "activatePaymentNotice_00000000006.xml",
    "activatePaymentNotice_00000000007.xml",
    "activatePaymentNotice_00000000008.xml",
    "activatePaymentNotice_00000000009.xml",
    "verifyPaymentNotice_00000000001.xml",
    "verifyPaymentNotice_00000000002.xml",
    "verifyPaymentNotice_00000000003.xml",
    "verifyPaymentNotice_00000000004.xml",
    "verifyPaymentNotice_00000000005.xml",
    "verifyPaymentNotice_00000000006.xml",
    "verifyPaymentNotice_00000000007.xml",
    "verifyPaymentNotice_00000000008.xml",
    "verifyPaymentNotice_00000000009.xml"
  ]) : toset([])
  name                   = each.key # File name on storage container.
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("", ["mock-nodo/FiscalCode_0000000000x/", each.key]) # Local file name.
}

# ------------------------------------------------------------------------------
# Uploading of OK responses for verify operation and KO responses for activate
# operation.
# ------------------------------------------------------------------------------
resource "azurerm_storage_blob" "stub_verify_ok_activate_ko" {
  for_each = var.install_nodo_mock ? toset([
    "activatePaymentNotice_00000000101.xml",
    "activatePaymentNotice_00000000102.xml",
    "activatePaymentNotice_00000000103.xml",
    "activatePaymentNotice_00000000104.xml",
    "activatePaymentNotice_00000000105.xml",
    "activatePaymentNotice_00000000106.xml",
    "activatePaymentNotice_00000000107.xml",
    "activatePaymentNotice_00000000108.xml",
    "activatePaymentNotice_00000000109.xml",
    "verifyPaymentNotice_00000000101.xml",
    "verifyPaymentNotice_00000000102.xml",
    "verifyPaymentNotice_00000000103.xml",
    "verifyPaymentNotice_00000000104.xml",
    "verifyPaymentNotice_00000000105.xml",
    "verifyPaymentNotice_00000000106.xml",
    "verifyPaymentNotice_00000000107.xml",
    "verifyPaymentNotice_00000000108.xml",
    "verifyPaymentNotice_00000000109.xml"
  ]) : toset([])
  name                   = each.key # File name on storage container.
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("", ["mock-nodo/FiscalCode_0000000010x/", each.key]) # Local file name.
}

# ------------------------------------------------------------------------------
# Uploading of KO responses for verify and activate operations.
# ------------------------------------------------------------------------------
resource "azurerm_storage_blob" "stub_verify_ok_activate_ok" {
  for_each = var.install_nodo_mock ? toset([
    "activatePaymentNotice_00000000201.xml",
    "activatePaymentNotice_00000000202.xml",
    "activatePaymentNotice_00000000203.xml",
    "activatePaymentNotice_00000000204.xml",
    "activatePaymentNotice_00000000205.xml",
    "activatePaymentNotice_00000000206.xml",
    "activatePaymentNotice_00000000207.xml",
    "activatePaymentNotice_00000000208.xml",
    "activatePaymentNotice_00000000209.xml",
    "verifyPaymentNotice_00000000201.xml",
    "verifyPaymentNotice_00000000202.xml",
    "verifyPaymentNotice_00000000203.xml",
    "verifyPaymentNotice_00000000204.xml",
    "verifyPaymentNotice_00000000205.xml",
    "verifyPaymentNotice_00000000206.xml",
    "verifyPaymentNotice_00000000207.xml",
    "verifyPaymentNotice_00000000208.xml",
    "verifyPaymentNotice_00000000209.xml",
    "outcome_4e2581e0ca454011830fe8f7fbd03a85.json",
    "outcome_37b0bb69ce774bc2bfeb485e107ae335.json",
    "payments.json"
  ]) : toset([])
  name                   = join("", ["0000000020x/", each.key]) # File name on storage container.
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("", ["mock-nodo/FiscalCode_0000000020x/", each.key]) # Local file name.
}

# ------------------------------------------------------------------------------
# Uploading of GEC responses.
# ------------------------------------------------------------------------------
resource "azurerm_storage_blob" "stub_gec" {
  for_each               = var.install_nodo_mock ? toset(["gec.json"]) : toset([])
  name                   = join("", ["GEC/", each.key]) # File name on storage container.
  storage_account_name   = azurerm_storage_account.mock[0].name
  storage_container_name = azurerm_storage_container.mock[0].name
  type                   = "Block"
  source                 = join("", ["mock-nodo/GEC/", each.key]) # Local file name.
}

# ------------------------------------------------------------------------------
# Client ID used by the mock to callback mil-payment-notice.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "client_id_mock_nodo" {
  name         = "client-id-mock-nodo"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Client secret used by the mock to callback mil-payment-notice.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "client_secret_mock_nodo" {
  name         = "client-secret-mock-nodo"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Mock API definition.
# ------------------------------------------------------------------------------
module "mock_nodo_api" {
  count               = var.install_nodo_mock ? 1 : 0
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-mock-nodo"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Nodo and GEC mock"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = var.nodo_rest_url

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = var.mock_nodo_path

  display_name          = "MockNodo"
  content_format        = "openapi"
  content_value         = file("${path.module}/mock-nodo/mock-nodo-openapi.yaml")
  product_ids           = [module.mil_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "mockSoap"
      xml_content = templatefile("policies/mil-mock-nodo-soap.xml", {
        mock_nodo_st  = azurerm_storage_account.mock[0].primary_blob_endpoint,
        nodo_soap_url = var.nodo_soap_url
      })
    },
    {
      operation_id = "mockRest"
      xml_content = templatefile("policies/mil-mock-nodo-rest.xml", {
        mock_nodo_st           = azurerm_storage_account.mock[0].primary_blob_endpoint,
        mil_auth_url           = "${module.apim.gateway_url}/${var.mil_auth_path}",
        mil_payment_notice_url = "${module.apim.gateway_url}/${var.mil_payment_notice_path}",
        client_id              = data.azurerm_key_vault_secret.client_id_mock_nodo.value,
        client_secret          = data.azurerm_key_vault_secret.client_secret_mock_nodo.value
      })
    },
    {
      operation_id = "mockGec"
      xml_content = templatefile("policies/mil-mock-nodo-gec.xml", {
        mock_nodo_st = azurerm_storage_account.mock[0].primary_blob_endpoint,
        gec_url      = var.gec_url
      })
    }
  ]
}