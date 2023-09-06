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
integr_vnet_cidr   = "10.230.12.0/24"  # 010.230.012.000 - 010.230.012.255
apim_snet_cidr     = "10.230.12.0/27"  # 010.230.012.000 - 010.230.012.031
intern_vnet_cidr   = "10.231.0.0/16"   # 010.231.000.000 - 010.231.255.255
appgw_snet_cidr    = "10.231.0.0/24"   # 010.231.000.000 - 010.231.000.255
data_snet_cidr     = "10.231.1.0/24"   # 010.231.001.000 - 010.231.001.255
app_snet_cidr      = "10.231.2.0/23"   # 010.231.002.000 - 010.231.003.255
github_runner_cidr = "10.231.250.0/23" # 010.231.250.000 - 010.231.250.255

#
# mil-functions
#
#mil_functions_image                          = "ghcr.io/pagopa/mil-functions:latest"
#mil_functions_quarkus_log_level              = "ERROR"
#mil_functions_app_log_level                  = "DEBUG"
#mil_functions_mongo_connect_timeout          = "5s"
#mil_functions_mongo_read_timeout             = "10s"
#mil_functions_mongo_server_selection_timeout = "5s"
#mil_functions_cpu                            = 0.5
#mil_functions_ephemeral_storage              = "1.0Gi"
#mil_functions_memory                         = "1Gi"
#mil_functions_max_replicas                   = 5
#mil_functions_min_replicas                   = 0

#
# mil-payment-notice
#
mil_payment_notice_quarkus_log_level                = "ERROR"
mil_payment_notice_app_log_level                    = "DEBUG"
mil_payment_notice_mongo_connect_timeout            = "5s"
mil_payment_notice_mongo_read_timeout               = "10s"
mil_payment_notice_mongo_server_selection_timeout   = "5s"
mil_payment_notice_node_soap_service_url            = "https://mil-d-apim.azure-api.net/mockNodo"
mil_payment_notice_node_soap_client_connect_timeout = 2000
mil_payment_notice_node_soap_client_read_timeout    = 2000
mil_payment_notice_node_rest_service_url            = "https://mil-d-apim.azure-api.net/mockNodo"
mil_payment_notice_rest_client_connect_timeout      = 2000
mil_payment_notice_rest_client_read_timeout         = 2000
mil_payment_notice_close_payment_max_retry          = 3
mil_payment_notice_closepayment_retry_after         = 5
mil_payment_notice_activatepayment_expiration_time  = 30000
mil_payment_notice_image                            = "ghcr.io/pagopa/mil-payment-notice@sha256:f50c7efe2d98deb600aa8533bfd2cd94d9ee2819a87dd5b1d2545a71b1253d80"
mil_payment_notice_openapi_descriptor               = "https://raw.githubusercontent.com/pagopa/mil-payment-notice/485d8f64402b54066a87c988b3973da4f9790db0/src/main/resources/META-INF/openapi.yaml"
mil_payment_notice_cpu                              = 0.5
mil_payment_notice_ephemeral_storage                = "1.0Gi"
mil_payment_notice_memory                           = "1.0Gi"
mil_payment_notice_max_replicas                     = 5
mil_payment_notice_min_replicas                     = 0
mil_payment_notice_closepayment_location_base_url   = "https://mil-d-apim.azure-api.net/mil-payment-notice"
mil_payment_notice_jwt_publickey_location           = "https://mil-d-apim.azure-api.net/mil-auth/.well-known/jwks.json"
#mil_payment_notice_node_soap_service_url = "https://api.uat.platform.pagopa.it/nodo-auth/node-for-psp/v1"
#mil_payment_notice_node_soap_service_url = "https://api.uat.platform.pagopa.it/nodo/node-for-psp/v1"
#mil_payment_notice_node_rest_service_url = "https://api.uat.platform.pagopa.it/nodo-auth/nodo-per-pm/v2"
#mil_payment_notice_node_rest_service_url = "https://api.uat.platform.pagopa.it/nodo/node-for-psp/v2"
#mil_payment_notice_node_rest_service_url = "https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v2"

#
# mil-fee-calculator
#
mil_fee_calculator_image                  = "ghcr.io/pagopa/mil-fee-calculator@sha256:7d8eebef93cd413241b0be7e3107cd107ba6a6642b0564e9e8ea7e9e4b947d6f"
mil_fee_calculator_openapi_descriptor     = "https://raw.githubusercontent.com/pagopa/mil-apis/a4aac33f6af1f7328c9a457c75622fd62ad00356/openapi-mono/fee.yaml"
mil_fee_calculator_quarkus_log_level      = "ERROR"
mil_fee_calculator_app_log_level          = "DEBUG"
mil_fee_calculator_gec_url                = "https://mil-d-apim.azure-api.net/mockNodo"
mil_fee_calculator_gec_connect_timeout    = 2000
mil_fee_calculator_gec_read_timeout       = 2000
mil_fee_calculator_cpu                    = 0.5
mil_fee_calculator_ephemeral_storage      = "1.0Gi"
mil_fee_calculator_memory                 = "1.0Gi"
mil_fee_calculator_max_replicas           = 5
mil_fee_calculator_min_replicas           = 0
mil_fee_calculator_jwt_publickey_location = "https://mil-d-apim.azure-api.net/mil-auth/.well-known/jwks.json"
#mil_fee_calculator_gec_url = "https://api.uat.platform.pagopa.it/afm/node/calculator-service/v1"

#
# mil-payment-notice and mil-fee-calculator
#
mil_acquirer_conf_url                = "https://mil-d-apim.azure-api.net"
mil_acquirer_conf_ver                = "1.0.0"
mil_acquirer_conf_connect_timeout    = 2000
mil_acquirer_conf_read_timeout       = 2000
mil_acquirer_conf_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-apis/a4aac33f6af1f7328c9a457c75622fd62ad00356/openapi-mono/acquirer-conf.yaml"

#
# mil-auth
#
mil_auth_quarkus_log_level  = "ERROR"
mil_auth_app_log_level      = "DEBUG"
mil_auth_cryptoperiod       = 86400000
mil_auth_keysize            = 4096
mil_auth_access_duration    = 900
mil_auth_refresh_duration   = 3600
mil_auth_json_logging       = false
mil_auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/f931b8a37490d8b13d5f8ae4043690a1ac773f19/src/main/resources/META-INF/openapi.yaml"
mil_auth_image              = "ghcr.io/pagopa/mil-auth@sha256:dfa71afd2f9cc58b085329cb63e6b55895f82350d1c28166063c67c3ca60ef76"
mil_auth_cpu                = 0.5
mil_auth_ephemeral_storage  = "1.0Gi"
mil_auth_memory             = "1.0Gi"
mil_auth_max_replicas       = 5
mil_auth_min_replicas       = 0
mil_auth_redis_db           = "9"

#
# mil-preset
#
mil_preset_quarkus_log_level              = "ERROR"
mil_preset_app_log_level                  = "DEBUG"
mil_preset_mongo_connect_timeout          = "5s"
mil_preset_mongo_read_timeout             = "10s"
mil_preset_mongo_server_selection_timeout = "5s"
mil_preset_image                          = "ghcr.io/pagopa/mil-preset@sha256:9a8d7daffc4c2da98af0cf0dacf253968388fd6d4ac0da6cf6f63450d2ecb3b6"
mil_preset_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-apis/6c6b07a95aa70a62217e6f9d02b5cc229b97ff14/openapi-mono/preset.yaml"
mil_preset_cpu                            = 0.5
mil_preset_ephemeral_storage              = "1.0Gi"
mil_preset_memory                         = "1.0Gi"
mil_preset_max_replicas                   = 5
mil_preset_min_replicas                   = 0
mil_preset_location_base_url              = "https://mil-d-apim.azure-api.net/mil-preset"
mil_preset_jwt_publickey_location         = "https://mil-d-apim.azure-api.net/mil-auth/.well-known/jwks.json"

#
# mil-idpay
#
mil_idpay_quarkus_log_level              = "ERROR"
mil_idpay_app_log_level                  = "DEBUG"
mil_idpay_mongo_connect_timeout          = "5s"
mil_idpay_mongo_read_timeout             = "10s"
mil_idpay_mongo_server_selection_timeout = "5s"
mil_idpay_image                          = "ghcr.io/pagopa/mil-idpay@sha256:f66ae55a4d3e5b2697955b572017c30201be0a9ea5577a2bef51a65b379657d7"
mil_idpay_openapi_descriptor             = "https://raw.githubusercontent.com/pagopa/mil-idpay/5cf9769a89d23b17d7ae44280b8503469b694306/src/main/resources/META-INF/openapi.yaml"
mil_idpay_cpu                            = 0.5
mil_idpay_ephemeral_storage              = "1.0Gi"
mil_idpay_memory                         = "1.0Gi"
mil_idpay_max_replicas                   = 5
mil_idpay_min_replicas                   = 0
mil_idpay_location_base_url              = "https://mil-d-apim.azure-api.net/mil-idpay"
mil_idpay_jwt_publickey_location         = "https://mil-d-apim.azure-api.net/mil-auth/.well-known/jwks.json"
mil_idpay_idpay_rest_api_url             = "https://1cb54e4c-ea9a-4465-becc-b5d15fcd63bf.mock.pstmn.io"

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
