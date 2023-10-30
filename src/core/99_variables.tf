#
# General variables definition
#
variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
  validation {
    condition = (
      length(var.env) <= 4
    )
    error_message = "Max length is 4 chars."
  }
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

#
# Specific variables definition
#
variable "dns_zone_mil_prefix" {
  type        = string
  description = "Product DNS zone name prefix."
}

variable "dns_external_domain" {
  type        = string
  description = "Organization external domain."
  default     = "pagopa.it"
}

variable "dns_default_ttl" {
  type        = number
  description = "Time-to-live (seconds)."
  default     = 3600
}

variable "integr_vnet_cidr" {
  type        = string
  description = "Integration Virtual Network CIDR."
}

variable "apim_snet_cidr" {
  type        = string
  description = "API Manager Subnet CIDR."
}

variable "intern_vnet_cidr" {
  type        = string
  description = "Internal Virtual Network CIDR."
}

variable "appgw_snet_cidr" {
  type        = string
  description = "App GW Subnet CIDR."
}

variable "data_snet_cidr" {
  type        = string
  description = "Data Subnet CIDR."
}

variable "app_snet_cidr" {
  type        = string
  description = "Application Subnet CIDR."
}

variable "github_runner_cidr" {
  type        = string
  description = "GitHub runner Subnet CIDR."
}

variable "vpn_snet_cidr" {
  type        = string
  description = "VPN Subnet CIDR."
}

#
# Monitor
#
variable "log_analytics_workspace" {
  type = object({
    sku               = string
    retention_in_days = number
    daily_quota_gb    = number
  })
  description = "Log Analytics Workspace variables"
  default = {
    sku               = "PerGB2018"
    retention_in_days = 30
    daily_quota_gb    = 1
  }
}

#
# App Gateway
#
variable "app_gateway" {
  type = object({
    min_capacity = number
    max_capacity = number
    waf_enabled  = bool
    sku_name     = string
    sku_tier     = string
  })
  description = "Application Gateway configuration"
}

#
# mil-functions specific.
#
#variable "mil_functions_image" {
#  type        = string
#  description = "Image of mil-functions microservice."
#  default     = "ghcr.io/pagopa/mil-functions:latest"
#}
#
#variable "mil_functions_quarkus_log_level" {
#  type        = string
#  description = "Log level for Quarkus platform."
#  default     = "ERROR"
#}
#
#variable "mil_functions_app_log_level" {
#  type        = string
#  description = "Log level for application."
#  default     = "DEBUG"
#}
#
#variable "mil_functions_mongo_connect_timeout" {
#  type        = string
#  description = "Mongo connect timeout."
#  default     = "5s"
#}
#
#variable "mil_functions_mongo_read_timeout" {
#  type        = string
#  description = "Mongo read timeout."
#  default     = "10s"
#}
#
#variable "mil_functions_mongo_server_selection_timeout" {
#  type        = string
#  description = "Mongo server selection timeout."
#  default     = "5s"
#}
#
#variable "mil_functions_cpu" {
#  description = "CPUs assigned to the container."
#  type        = number
#  default     = 0.5
#}
#
#variable "mil_functions_ephemeral_storage" {
#  type        = string
#  default     = "1.0Gi"
#  description = "Ephemeral storage assigned to the container."
#}
#
#variable "mil_functions_memory" {
#  type        = string
#  description = "Memory assigned to the container."
#  default     = "1.0Gi"
#}
#
#variable "mil_functions_max_replicas" {
#  type        = number
#  description = "Max number of replicas."
#  default     = 5
#}
#
#variable "mil_functions_min_replicas" {
#  type        = number
#  description = "Min number of replicas."
#  default     = 0
#}

#
# mil-payment-notice specific
#
variable "mil_payment_notice_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_payment_notice_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_payment_notice_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_payment_notice_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_payment_notice_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_payment_notice_node_soap_service_url" {
  type    = string
  default = null
}

variable "mil_payment_notice_node_soap_client_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_node_soap_client_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_node_rest_service_url" {
  type    = string
  default = null
}

variable "mil_payment_notice_rest_client_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_rest_client_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_payment_notice_close_payment_max_retry" {
  type    = number
  default = 3
}

variable "mil_payment_notice_closepayment_retry_after" {
  type    = number
  default = 30
}

variable "mil_payment_notice_activatepayment_expiration_time" {
  type    = number
  default = 30000
}

variable "mil_payment_notice_image" {
  type = string
}

variable "mil_payment_notice_cpu" {
  type    = number
  default = 0.5
}

variable "mil_payment_notice_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_payment_notice_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_payment_notice_max_replicas" {
  type    = number
  default = 5
}

variable "mil_payment_notice_min_replicas" {
  type    = number
  default = 0
}

variable "mil_payment_notice_closepayment_location_base_url" {
  type    = string
  default = null
}

variable "mil_payment_notice_openapi_descriptor" {
  type = string
}

variable "mil_payment_notice_jwt_publickey_location" {
  type    = string
  default = null
}

#
# mil-fee-calculator specific
#
variable "mil_fee_calculator_image" {
  type = string
}

variable "mil_fee_calculator_openapi_descriptor" {
  type = string
}

variable "mil_fee_calculator_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_fee_calculator_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_fee_calculator_gec_url" {
  type    = string
  default = null
}

variable "mil_fee_calculator_gec_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_fee_calculator_gec_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_fee_calculator_cpu" {
  type    = number
  default = 0.5
}

variable "mil_fee_calculator_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_fee_calculator_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_fee_calculator_max_replicas" {
  type    = number
  default = 5
}

variable "mil_fee_calculator_min_replicas" {
  type    = number
  default = 0
}

variable "mil_fee_calculator_jwt_publickey_location" {
  type    = string
  default = null
}

#
# mil-payment-notice and mil-fee-calculator specific
#
variable "mil_acquirer_conf_url" {
  type = string
}

variable "mil_acquirer_conf_ver" {
  type    = string
  default = "1.0.0"
}

variable "mil_acquirer_conf_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_acquirer_conf_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_acquirer_conf_openapi_descriptor" {
  type = string
}

#
# mil-auth specific
#
variable "mil_auth_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_auth_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_auth_cryptoperiod" {
  type    = number
  default = 86400000
}

variable "mil_auth_keysize" {
  type    = number
  default = 4096
}

variable "mil_auth_access_duration" {
  type    = number
  default = 900
}

variable "mil_auth_refresh_duration" {
  type    = number
  default = 3600
}

variable "mil_auth_openapi_descriptor" {
  type = string
}

variable "mil_auth_image" {
  type = string
}

variable "mil_auth_cpu" {
  type    = number
  default = 0.5
}

variable "mil_auth_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_auth_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_auth_max_replicas" {
  type    = number
  default = 5
}

variable "mil_auth_min_replicas" {
  type    = number
  default = 0
}

variable "mil_auth_azure_keyvault_api_version" {
  type    = string
  default = "7.4"
}

#
# mil-preset specific
#
variable "mil_preset_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_preset_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_preset_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_preset_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_preset_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_preset_location_base_url" {
  type    = string
  default = null
}

variable "mil_preset_image" {
  type = string
}

variable "mil_preset_cpu" {
  type    = number
  default = 0.5
}

variable "mil_preset_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_preset_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_preset_max_replicas" {
  type    = number
  default = 5
}

variable "mil_preset_min_replicas" {
  type    = number
  default = 0
}

variable "mil_preset_openapi_descriptor" {
  type = string
}

variable "mil_preset_jwt_publickey_location" {
  type    = string
  default = null
}

#
# mil-idpay specific
#
variable "mil_idpay_image" {
  type = string
}

variable "mil_idpay_cpu" {
  type    = number
  default = 0.5
}

variable "mil_idpay_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_idpay_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_idpay_max_replicas" {
  type    = number
  default = 5
}

variable "mil_idpay_min_replicas" {
  type    = number
  default = 0
}

variable "mil_idpay_openapi_descriptor" {
  type = string
}

variable "mil_idpay_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_idpay_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_idpay_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_idpay_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_idpay_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

variable "mil_idpay_transaction_max_retry" {
  type    = number
  default = 3
}

variable "mil_idpay_transaction_retry_after" {
  type    = number
  default = 30
}

variable "mil_idpay_location_base_url" {
  type    = string
  default = null
}

variable "mil_idpay_idpay_rest_api_url" {
  type    = string
  default = null
}

variable "mil_idpay_jwt_publickey_location" {
  type    = string
  default = null
}

variable "mil_idpay_ipzs_rest_api_url" {
  type    = string
  default = null
}

variable "mil_idpay_azuread_resp_api_url" {
  type    = string
  default = "https://login.microsoftonline.com"
}

variable "mil_idpay_cryptoperiod" {
  type    = number
  default = 86400000
}

variable "mil_idpay_keysize" {
  type    = number
  default = 4096
}

#
# idpay-ipzs-mock specific
#
variable "mil_idpay_ipzs_mock_image" {
  type = string
}

variable "mil_idpay_ipzs_mock_cpu" {
  type    = number
  default = 0.5
}

variable "mil_idpay_ipzs_mock_ephemeral_storage" {
  type    = string
  default = "1.0Gi"
}

variable "mil_idpay_ipzs_mock_memory" {
  type    = string
  default = "1.0Gi"
}

variable "mil_idpay_ipzs_mock_max_replicas" {
  type    = number
  default = 5
}

variable "mil_idpay_ipzs_mock_min_replicas" {
  type    = number
  default = 0
}

variable "mil_idpay_ipzs_mock_openapi_descriptor" {
  type = string
}

variable "mil_idpay_ipzs_mock_quarkus_log_level" {
  type    = string
  default = "ERROR"
}

variable "mil_idpay_ipzs_mock_app_log_level" {
  type    = string
  default = "DEBUG"
}

variable "mil_idpay_ipzs_mock_mongo_connect_timeout" {
  type    = string
  default = "5s"
}

variable "mil_idpay_ipzs_mock_mongo_read_timeout" {
  type    = string
  default = "10s"
}

variable "mil_idpay_ipzs_mock_mongo_server_selection_timeout" {
  type    = string
  default = "5s"
}

#
# API Manager specific.
#
variable "apim_sku" {
  type        = string
  description = "String made up of two components separated by an underscore: the 1st component is the name (Consumption, Developer, Basic, Standard, Premium); the 2nd component is the capacity (it must be an integer greater than 0)."
}

variable "apim_publisher_name" {
  type        = string
  description = "The name of the publisher."
  default     = "PagoPA S.p.A."
}

#
# VPN specific.
#
variable "vpn_sku" {
  type = string
}

variable "vpn_pip_sku" {
  type = string
}