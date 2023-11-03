# ==============================================================================
# This file contains stuff needed to run mil-fee-calculator microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
variable "gec_url" {
  description = "URL of the real GEC."
  type        = string
}

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
  default = 1
}

variable "mil_fee_calculator_memory" {
  type    = string
  default = "2Gi"
}

variable "mil_fee_calculator_max_replicas" {
  type    = number
  default = 10
}

variable "mil_fee_calculator_min_replicas" {
  type    = number
  default = 1
}

variable "mil_fee_calculator_rest_client_connect_timeout" {
  type    = number
  default = 2000
}

variable "mil_fee_calculator_rest_client_read_timeout" {
  type    = number
  default = 2000
}

variable "mil_fee_calculator_path" {
  type    = string
  default = "mil-fee-calculator"
}

# ------------------------------------------------------------------------------
# Get API key of GEC from key vault.
# ------------------------------------------------------------------------------
data "azurerm_key_vault_secret" "gec_subscription_key" {
  name         = "gec-subscription-key"
  key_vault_id = module.key_vault.id
}

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "mil_fee_calculator" {
  name                         = "${local.project}-fee-calculator-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "mil-fee-calculator"
      image  = var.mil_fee_calculator_image
      cpu    = var.mil_fee_calculator_cpu
      memory = var.mil_fee_calculator_memory

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }

      env {
        name  = "feecalculator.quarkus-log-level"
        value = var.mil_fee_calculator_quarkus_log_level
      }

      env {
        name  = "feecalculator.app-log-level"
        value = var.mil_fee_calculator_app_log_level
      }

      env {
        name  = "rest-client-fees-url"
        value = var.install_nodo_mock ? "${module.apim.gateway_url}/${var.mock_nodo_path}" : var.gec_url
      }

      env {
        name        = "ocp-apim-subscription"
        secret_name = "gec-subscription-key"
      }

      env {
        name  = "fees.service.connect-timeout"
        value = var.mil_fee_calculator_gec_connect_timeout
      }

      env {
        name  = "fees.service.read-timeout"
        value = var.mil_fee_calculator_gec_read_timeout
      }

      env {
        name  = "mil.rest-service.url"
        value = azurerm_storage_account.conf.primary_blob_endpoint
      }

      env {
        name  = "mil.rest-service.connect-timeout"
        value = var.mil_fee_calculator_rest_client_connect_timeout
      }

      env {
        name  = "mil.rest-service.read-timeout"
        value = var.mil_fee_calculator_rest_client_read_timeout
      }

      env {
        name  = "jwt-publickey-location"
        value = "${module.apim.gateway_url}/${var.mil_auth_path}/.well-known/jwks.json"
      }
    }

    max_replicas = var.mil_fee_calculator_max_replicas
    min_replicas = var.mil_fee_calculator_min_replicas
  }

  secret {
    name  = "gec-subscription-key"
    value = data.azurerm_key_vault_secret.gec_subscription_key.value
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = formatdate("YYYYMMDDhhmmssZZZZ", timestamp())
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Query for stdout/stdin of container app.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "fee_calculator_ca_console_logs" {
  query_pack_id = azurerm_log_analytics_query_pack.query_pack.id
  body          = "ContainerAppConsoleLogs_CL | where ContainerName_s == 'mil-fee-calculator' | where time_t > ago(60m) | sort by time_t asc | extend local_time = substring(Log_s, 0, 23) | extend request_id = extract('\\[(.*?)\\]', 1, Log_s) | extend log_level = extract('\\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\\]', 1, Log_s) | project local_time, request_id, log_level, Log_s"
  display_name  = "*** mil-fee-calculator - last hour logs ***"
}

# ------------------------------------------------------------------------------
# API definition.
# ------------------------------------------------------------------------------
module "fee_calculator_api" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v7.14.0"
  name                = "${local.project}-fee-calculator"
  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name
  description         = "Fee Calculator Microservice for Multi-channel Integration Layer of SW Client Project"
  protocols           = ["https"]

  # Absolute URL of the backend service implementing this API.
  service_url = "https://${azurerm_container_app.mil_fee_calculator.ingress[0].fqdn}"

  # The Path for this API Management API, which is a relative URL which uniquely
  # identifies this API and all of its resource paths within the API Management
  # Service.
  path = var.mil_fee_calculator_path

  display_name          = "fee calculator"
  content_format        = "openapi-link"
  content_value         = var.mil_fee_calculator_openapi_descriptor
  product_ids           = [module.mil_product.product_id]
  subscription_required = false
}

# ------------------------------------------------------------------------------
# API diagnostic.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_api_diagnostic" "fee_calculator_api" {
  identifier               = "applicationinsights"
  resource_group_name      = module.apim.resource_group_name
  api_management_name      = module.apim.name
  api_name                 = module.fee_calculator_api.name
  api_management_logger_id = module.apim.logger_id

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  frontend_response {
    body_bytes = 8192
  }

  backend_request {
    body_bytes = 8192
    headers_to_log = [
      "RequestId",
      "Version",
      "AcquirerId",
      "MerchantId",
      "Channel",
      "TerminalId"
    ]
  }

  backend_response {
    body_bytes = 8192
  }
}