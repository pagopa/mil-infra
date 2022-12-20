# general

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