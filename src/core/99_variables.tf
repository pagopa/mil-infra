#
# General variables definition.
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
# Specific variables definition.
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

variable "dmz_snet_cidr" {
  type        = string
  description = "DMZ Subnet CIDR."
}

variable "data_snet_cidr" {
  type        = string
  description = "Data Subnet CIDR."
}

variable "app_snet_cidr" {
  type        = string
  description = "Application Subnet CIDR."
}

#
# mil-functions specific.
#
variable "mil_functions_image" {
  type        = string
  description = "Image of mil-functions microservice."
  default     = "ghcr.io/pagopa/mil-functions:latest"
}

variable "mil_functions_quarkus_log_level" {
  type        = string
  description = "Log level for Quarkus platform."
  default     = "ERROR"
}

variable "mil_functions_app_log_level" {
  type        = string
  description = "Log level for application."
  default     = "DEBUG"
}

variable "mil_functions_mongo_connect_timeout" {
  type        = string
  description = "Mongo connect timeout."
  default     = "5s"
}

variable "mil_functions_mongo_read_timeout" {
  type        = string
  description = "Mongo read timeout."
  default     = "10s"
}

variable "mil_functions_mongo_server_selection_timeout" {
  type        = string
  description = "Mongo server selection timeout."
  default     = "5s"
}

variable "mil_functions_cpu" {
  type        = number
  description = "CPUs assigned to the container."
  default     = 0.5
}

variable "mil_functions_ephemeral_storage" {
  type        = string
  description = "Ephemeral storage assigned to the container."
  default     = "1.0Gi"
}

variable "mil_functions_memory" {
  type        = string
  description = "Memory assigned to the container."
  default     = "1.0Gi"
}

variable "mil_functions_max_replicas" {
  type        = number
  description = "Max number of replicas."
  default     = 5
}

variable "mil_functions_min_replicas" {
  type        = number
  description = "Min number of replicas."
  default     = 0
}

# API Manager specific.
variable "apim_sku" {
  type        = string
  description = "String made up of two components separated by an underscore: the 1st component is the name (Consumption, Developer, Basic, Standard, Premium); the 2nd component is the capacity (it must be an integer greater than 0)."
}

variable "apim_lock_enable" {
  type        = bool
  description = "Block accidental deletions."
  default     = false
}

variable "apim_publisher_name" {
  type        = string
  description = "The name of the publisher."
  default     = "PagoPA S.p.A."
}

variable "apim_publisher_email" {
  type        = string
  description = "The e-mail of the publisher."
  default     = "dummy@pagopa.it"
}

variable "apim_redis_cache_id" {
  type        = string
  description = "The resource ID of the Cache for Redis."
  default     = null
}