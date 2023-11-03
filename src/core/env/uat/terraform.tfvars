#
# General
#
env_short      = "u"
env            = "uat"
prefix         = "mil"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "mil"
  Source      = "https://github.com/pagopa/mil-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# DNS
#
dns_zone_mil_prefix = "uat.mil"

#
# CIDRs
#
integr_vnet_cidr = "10.230.12.0/24" # 010.230.012.000 - 010.230.012.255
apim_snet_cidr   = "10.230.12.0/27" # 010.230.012.000 - 010.230.012.031
intern_vnet_cidr = "10.231.0.0/16"  # 010.231.000.000 - 010.231.255.255
appgw_snet_cidr  = "10.231.0.0/24"  # 010.231.000.000 - 010.231.000.255
data_snet_cidr   = "10.231.1.0/24"  # 010.231.001.000 - 010.231.001.255
app_snet_cidr    = "10.231.2.0/23"  # 010.231.002.000 - 010.231.003.255
vpn_snet_cidr    = "10.231.4.0/24"  # 010.231.004.000 - 010.231.004.255

#
# If true CosmosDB will be protected with private link.
#
armored_cosmosdb = true

#
# If true the event hub will be protected with private link.
#
armored_event_hub = true

#
# If true the storage account containing the acquirers configuration will be
# protected with a private link and the storage containers will be private.
#
armored_storage_account_for_acquirers_conf = false

#
# If true the mock of the Nodo and GEC will be installed.
#
install_nodo_mock = true

#
# If true the mock of the IDPay and IPZS will be installed.
#
install_idpay_ipzs_mock = false

#
# URL of the SOAP endpoint (verify and activate operations) of the real Nodo.
# For UAT, one of the following value should work:
#   1) https://api.uat.platform.pagopa.it/nodo-auth/node-for-psp/v1
#   2) https://api.uat.platform.pagopa.it/nodo/node-for-psp/v1
#
nodo_soap_url = "https://api.uat.platform.pagopa.it/nodo/node-for-psp/v1"

#
# URL of the REST endpoint (close payment) of the real Nodo.
# For UAT, one of the following value should work:
#   1) https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v1
#   2) https://api.uat.platform.pagopa.it/nodo-auth/nodo-per-pm/v2
#   3) https://api.uat.platform.pagopa.it/nodo/node-for-psp/v2
#   4) https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v2
#
nodo_rest_url = "https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v1"

#
# URL of the real GEC.
# For UAT, one of the following value should work:
#   1) https://api.uat.platform.pagopa.it/afm/node/calculator-service/v1
#
gec_url = "https://api.uat.platform.pagopa.it/afm/node/calculator-service/v1"

#
# mil-payment-notice
#
mil_payment_notice_armored_redis                    = false
mil_payment_notice_quarkus_log_level                = "ERROR"
mil_payment_notice_app_log_level                    = "DEBUG"
mil_payment_notice_mongo_connect_timeout            = "5s"
mil_payment_notice_mongo_read_timeout               = "10s"
mil_payment_notice_mongo_server_selection_timeout   = "5s"
mil_payment_notice_node_soap_client_connect_timeout = 2000
mil_payment_notice_node_soap_client_read_timeout    = 2000
mil_payment_notice_rest_client_connect_timeout      = 2000
mil_payment_notice_rest_client_read_timeout         = 2000
mil_payment_notice_closepayment_max_retry           = 10
mil_payment_notice_closepayment_retry_after         = 1
mil_payment_notice_activatepayment_expiration_time  = 30000
mil_payment_notice_image                            = "ghcr.io/pagopa/mil-payment-notice:2.2.1-rc"
mil_payment_notice_openapi_descriptor               = "https://raw.githubusercontent.com/pagopa/mil-payment-notice/main/src/main/resources/META-INF/openapi.yaml"
mil_payment_notice_cpu                              = 1
mil_payment_notice_memory                           = "2Gi"
mil_payment_notice_max_replicas                     = 10
mil_payment_notice_min_replicas                     = 1

#
# mil-fee-calculator
#
mil_fee_calculator_image               = "ghcr.io/pagopa/mil-fee-calculator:1.2.1-rc"
mil_fee_calculator_openapi_descriptor  = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/fee.yaml"
mil_fee_calculator_quarkus_log_level   = "ERROR"
mil_fee_calculator_app_log_level       = "DEBUG"
mil_fee_calculator_gec_connect_timeout = 2000
mil_fee_calculator_gec_read_timeout    = 2000
mil_fee_calculator_cpu                 = 1
mil_fee_calculator_memory              = "2Gi"
mil_fee_calculator_max_replicas        = 10
mil_fee_calculator_min_replicas        = 1

#
# mil-auth
#
mil_auth_armored_storage_account           = true
mil_auth_armored_key_vault                 = true
mil_auth_quarkus_log_level                 = "ERROR"
mil_auth_app_log_level                     = "DEBUG"
mil_auth_quarkus_rest_client_logging_scope = "all"
mil_auth_cryptoperiod                      = 86400000
mil_auth_keysize                           = 4096
mil_auth_access_duration                   = 900
mil_auth_refresh_duration                  = 3600
mil_auth_openapi_descriptor                = "https://raw.githubusercontent.com/pagopa/mil-auth/main/src/main/resources/META-INF/openapi.yaml"
mil_auth_image                             = "ghcr.io/pagopa/mil-auth:1.10.0-RC"
mil_auth_cpu                               = 1
mil_auth_memory                            = "2Gi"
mil_auth_max_replicas                      = 10
mil_auth_min_replicas                      = 1
mil_auth_azure_keyvault_api_version        = "7.4"

#
# mil-preset
#
mil_preset_quarkus_log_level              = "ERROR"
mil_preset_app_log_level                  = "DEBUG"
mil_preset_mongo_connect_timeout          = "5s"
mil_preset_mongo_read_timeout             = "10s"
mil_preset_mongo_server_selection_timeout = "5s"
mil_preset_image                          = "ghcr.io/pagopa/mil-preset@sha256:503de693c32776db7186c299c381f42d0b86b2dc6adf93c014ad7b6fd2a99004"
mil_preset_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-apis/6c6b07a95aa70a62217e6f9d02b5cc229b97ff14/openapi-mono/preset.yaml"
mil_preset_cpu                            = 1
mil_preset_memory                         = "2Gi"
mil_preset_max_replicas                   = 10
mil_preset_min_replicas                   = 1

#
# mil-idpay
#
mil_idpay_armored_key_vault              = false
mil_idpay_quarkus_log_level              = "ERROR"
mil_idpay_app_log_level                  = "DEBUG"
mil_idpay_mongo_connect_timeout          = "5s"
mil_idpay_mongo_read_timeout             = "10s"
mil_idpay_mongo_server_selection_timeout = "5s"
mil_idpay_image                          = "ghcr.io/pagopa/mil-idpay:latest"
mil_idpay_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-idpay/main/src/main/resources/META-INF/openapi.yaml"
mil_idpay_cpu                            = 1
mil_idpay_memory                         = "2Gi"
mil_idpay_max_replicas                   = 10
mil_idpay_min_replicas                   = 1
mil_idpay_location_base_url              = "https://mil-u-apim.azure-api.net/mil-idpay"
mil_idpay_jwt_publickey_location         = "https://mil-u-apim.azure-api.net/mil-auth/.well-known/jwks.json"
mil_idpay_idpay_rest_api_url             = "https://mil-d-apim.azure-api.net/idpay-ipzs-mock"
mil_idpay_ipzs_rest_api_url              = "https://mil-d-apim.azure-api.net/idpay-ipzs-mock"
mil_idpay_azuread_resp_api_url           = "https://login.microsoftonline.com"
mil_idpay_cryptoperiod                   = 86400000
mil_idpay_keysize                        = 4096

#
# APIM
#
apim_sku = "Developer_1"

#
# App gateway
#
app_gateway = {
  min_capacity = 0
  max_capacity = 2
  waf_enabled  = false
  sku_name     = "Standard_v2"
  sku_tier     = "Standard_v2"
}

#
# VPN
#
vpn_sku     = "VpnGw2"
vpn_pip_sku = "Basic"