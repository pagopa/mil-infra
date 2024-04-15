#
# General
#
env_short      = "d"
env            = "dev"
prefix         = "mil"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "mil"
  Source      = "https://github.com/pagopa/mil-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# DNS
#
dns_zone_mil_prefix = "dev.mil"

#
# CIDRs
#
integr_vnet_cidr       = "10.230.12.0/24" # 010.230.012.000 - 010.230.012.255
apim_snet_cidr         = "10.230.12.0/27" # 010.230.012.000 - 010.230.012.031
intern_vnet_cidr       = "10.231.0.0/16"  # 010.231.000.000 - 010.231.255.255
appgw_snet_cidr        = "10.231.0.0/24"  # 010.231.000.000 - 010.231.000.255
app_snet_cidr          = "10.231.2.0/23"  # 010.231.002.000 - 010.231.003.255
vpn_snet_cidr          = "10.231.4.0/24"  # 010.231.004.000 - 010.231.004.255
dnsforwarder_snet_cidr = "10.231.5.0/29"  # 010.231.005.000 - 010.231.005.007

#
# If true the mock of the Nodo and GEC will be installed.
#
install_nodo_mock = true

#
# If true the mock of the IDPay and IPZS will be installed.
#
install_idpay_mock = true

#
# If true the mock of the IDPay and IPZS will be installed.
#
install_ipzs_mock = true

#
# URL of the SOAP endpoint (verify and activate operations) of the real Nodo.
# For UAT, one of the following value should work:
#   1) https://api.uat.platform.pagopa.it/nodo-auth/node-for-psp/v1
#   2) https://api.uat.platform.pagopa.it/nodo/node-for-psp/v1
#
nodo_soap_url = "https://api.uat.platform.pagopa.it/nodo-auth/node-for-psp/v1"

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
mil_payment_notice_quarkus_log_level                = "ERROR"
mil_payment_notice_app_log_level                    = "DEBUG"
mil_payment_notice_mongo_connect_timeout            = "5s"
mil_payment_notice_mongo_read_timeout               = "10s"
mil_payment_notice_mongo_server_selection_timeout   = "5s"
mil_payment_notice_node_soap_client_connect_timeout = 2000
mil_payment_notice_node_soap_client_read_timeout    = 2000
mil_payment_notice_node_logging_enabled             = pretty
mil_payment_notice_rest_client_connect_timeout      = 2000
mil_payment_notice_rest_client_read_timeout         = 2000
mil_payment_notice_closepayment_max_retry           = 10
mil_payment_notice_closepayment_retry_after         = 1
mil_payment_notice_activatepayment_expiration_time  = 30000
mil_payment_notice_image                            = "ghcr.io/pagopa/mil-payment-notice:latest"
mil_payment_notice_openapi_descriptor               = "https://raw.githubusercontent.com/pagopa/mil-payment-notice/main/src/main/resources/META-INF/openapi.yaml"
mil_payment_notice_cpu                              = 1
mil_payment_notice_memory                           = "2Gi"
mil_payment_notice_max_replicas                     = 10
mil_payment_notice_min_replicas                     = 1

#
# mil-fee-calculator
#
mil_fee_calculator_image               = "ghcr.io/pagopa/mil-fee-calculator:latest"
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
mil_auth_quarkus_log_level                 = "ERROR"
mil_auth_app_log_level                     = "DEBUG"
mil_auth_quarkus_rest_client_logging_scope = "all"
mil_auth_cryptoperiod                      = 86400000
mil_auth_keysize                           = 4096
mil_auth_access_duration                   = 900
mil_auth_refresh_duration                  = 3600
mil_auth_openapi_descriptor                = "https://raw.githubusercontent.com/pagopa/mil-auth/main/src/main/resources/META-INF/openapi.yaml"
mil_auth_image                             = "ghcr.io/pagopa/mil-auth:latest"
mil_auth_cpu                               = 1
mil_auth_memory                            = "2Gi"
mil_auth_max_replicas                      = 10
mil_auth_min_replicas                      = 1

#
# mil-preset
#
mil_preset_quarkus_log_level              = "ERROR"
mil_preset_app_log_level                  = "DEBUG"
mil_preset_mongo_connect_timeout          = "5s"
mil_preset_mongo_read_timeout             = "10s"
mil_preset_mongo_server_selection_timeout = "5s"
mil_preset_image                          = "ghcr.io/pagopa/mil-preset:latest"
mil_preset_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-apis/main/openapi-mono/preset.yaml"
mil_preset_cpu                            = 1
mil_preset_memory                         = "2Gi"
mil_preset_max_replicas                   = 10
mil_preset_min_replicas                   = 1


#
# mil-terminal-registry
#
mil_terminal_registry_quarkus_log_level              = "ERROR"
mil_terminal_registry_app_log_level                  = "DEBUG"
mil_terminal_registry_image                          = "ghcr.io/pagopa/mil-terminal-registry:latest"
mil_terminal_registry_cpu                            = 1
mil_terminal_registry_memory                         = "2Gi"
mil_terminal_registry_max_replicas                   = 10
mil_terminal_registry_min_replicas                   = 1
mil_terminal_registry_mongo_connect_timeout          = "5s"
mil_terminal_registry_mongo_read_timeout             = "10s"
mil_terminal_registry_mongo_server_selection_timeout = "5s"
mil_terminal_registry_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-terminal-registry/main/src/main/resources/META-INF/openapi.yaml"


#
# mil-idpay
#
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
mil_idpay_idpay_rest_api_url             = "https://api.uat.cstar.pagopa.it"
mil_idpay_ipzs_rest_api_url              = "https://mil-d-apim.azure-api.net/idpay-ipzs-mock"
mil_idpay_cryptoperiod                   = 86400000
mil_idpay_keysize                        = 4096
mil_idpay_transaction_max_retry          = 10
mil_idpay_transaction_retry_after        = 5

#
# mock-idpay-ipzs
#
mock_idpay_ipzs_quarkus_log_level              = "ERROR"
mock_idpay_ipzs_app_log_level                  = "DEBUG"
mock_idpay_ipzs_mongo_connect_timeout          = "5s"
mock_idpay_ipzs_mongo_read_timeout             = "10s"
mock_idpay_ipzs_mongo_server_selection_timeout = "5s"
mock_idpay_ipzs_image                          = "ghcr.io/pagopa/idpay-ipzs-mock:latest"
mock_idpay_ipzs_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/idpay-ipzs-mock/main/src/main/resources/META-INF/openapi.yml"
mock_idpay_ipzs_cpu                            = 1
mock_idpay_ipzs_memory                         = "2Gi"
mock_idpay_ipzs_max_replicas                   = 5
mock_idpay_ipzs_min_replicas                   = 1
mock_idpay_rest_api_url                        = "https://api-io.uat.cstar.pagopa.it"
mock_ipzs_call_idpay_to_link_user_to_trx       = "no"

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
vpn_sku                  = "VpnGw2"
vpn_pip_sku              = "Basic"
vpn_client_address_space = "172.16.2.0/24" # 172.016.002.000 - 172.016.002.255
