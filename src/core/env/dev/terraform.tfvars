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
integr_vnet_cidr = "10.230.12.0/24" # 010.230.012.000 - 010.230.012.255
apim_snet_cidr   = "10.230.12.0/27" # 010.230.012.000 - 010.230.012.031

intern_vnet_cidr   = "10.231.0.0/16"   # 010.231.000.000 - 010.231.255.255
appgw_snet_cidr    = "10.231.0.0/24"   # 010.231.000.000 - 010.231.000.255
data_snet_cidr     = "10.231.1.0/24"   # 010.231.001.000 - 010.231.001.255
app_snet_cidr      = "10.231.2.0/23"   # 010.231.002.000 - 010.231.003.255
github_runner_cidr = "10.231.250.0/23" # 010.231.250.000 - 010.231.250.255

#
# mil-functions
#
mil_functions_image                          = "ghcr.io/pagopa/mil-functions:latest"
mil_functions_quarkus_log_level              = "ERROR"
mil_functions_app_log_level                  = "DEBUG"
mil_functions_mongo_connect_timeout          = "5s"
mil_functions_mongo_read_timeout             = "10s"
mil_functions_mongo_server_selection_timeout = "5s"
mil_functions_cpu                            = 0.5
mil_functions_ephemeral_storage              = "1.0Gi"
mil_functions_memory                         = "1Gi"
mil_functions_max_replicas                   = 5
mil_functions_min_replicas                   = 0

#
# mil-payment-notice
#
mil_payment_notice_quarkus_log_level                = "ERROR"
mil_payment_notice_app_log_level                    = "DEBUG"
mil_payment_notice_mongo_connect_timeout            = "5s"
mil_payment_notice_mongo_read_timeout               = "10s"
mil_payment_notice_mongo_server_selection_timeout   = "5s"
mil_payment_notice_node_soap_service_url            = "https://api.uat.platform.pagopa.it/nodo-auth/node-for-psp/v1"
#mil_payment_notice_node_soap_service_url            = "https://api.uat.platform.pagopa.it/nodo/node-for-psp/v1"
mil_payment_notice_node_soap_client_connect_timeout = 2000
mil_payment_notice_node_soap_client_read_timeout    = 2000
mil_payment_notice_node_rest_service_url            = "https://api.uat.platform.pagopa.it/nodo-auth/nodo-per-pm/v2/closepayment"
#mil_payment_notice_node_rest_service_url            = "https://api.uat.platform.pagopa.it/nodo/node-for-psp/v2/closepayment"
#                                                       https://api.uat.platform.pagopa.it/nodo/nodo-per-pm/v2/closepayment
mil_payment_notice_rest_client_connect_timeout      = 2000
mil_payment_notice_rest_client_read_timeout         = 2000
mil_payment_notice_close_payment_max_retry          = 3
mil_payment_notice_closepayment_retry_after         = 30
mil_payment_notice_activatepayment_expiration_time  = 30000
mil_payment_notice_image                            = "ghcr.io/pagopa/mil-payment-notice:latest"
mil_payment_notice_cpu                              = 0.5
mil_payment_notice_ephemeral_storage                = "1.0Gi"
mil_payment_notice_memory                           = "1.0Gi"
mil_payment_notice_max_replicas                     = 5
mil_payment_notice_min_replicas                     = 0

#
# mil-fee-calculator
#
mil_fee_calculator_image                          = "ghcr.io/pagopa/mil-fee-calculator:latest"
mil_fee_calculator_quarkus_log_level              = "ERROR"
mil_fee_calculator_app_log_level                  = "DEBUG"
mil_fee_calculator_mongo_connect_timeout          = "5s"
mil_fee_calculator_mongo_read_timeout             = "10s"
mil_fee_calculator_mongo_server_selection_timeout = "5s"
mil_fee_calculator_gec_url                        = "https://api.uat.platform.pagopa.it/afm/node/calculator-service/v1/fees"
mil_fee_calculator_gec_connect_timeout            = 2000
mil_fee_calculator_gec_read_timeout               = 2000
mil_fee_calculator_cpu                            = 0.5
mil_fee_calculator_ephemeral_storage              = "1.0Gi"
mil_fee_calculator_memory                         = "1.0Gi"
mil_fee_calculator_max_replicas                   = 5
mil_fee_calculator_min_replicas                   = 0

#
# mil-payment-notice and mil-fee-calculator
#
mil_acquirer_conf_url = "https://mil-d-apim.azure-api.net"
mil_acquirer_conf_ver = "1.0.0"

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
