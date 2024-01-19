module "appgw_cert" {
  source            = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v7.14.0"
  prefix            = var.prefix
  env               = var.env_short
  key_vault_name    = module.key_vault.name
  subscription_name = format("%s-%s", upper(var.env), var.prefix)
}