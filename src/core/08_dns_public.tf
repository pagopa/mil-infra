# ==============================================================================
# This file contains stuff needed to setup the public DNS.
# ==============================================================================

# ------------------------------------------------------------------------------
# Variables definition.
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# DNS zone.
# ------------------------------------------------------------------------------
resource "azurerm_dns_zone" "mil" {
  name                = "${var.dns_zone_mil_prefix}.${var.dns_external_domain}"
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# This is executed for PROD ONLY and gives Public DNS Delegation to DEV.
# ------------------------------------------------------------------------------
resource "azurerm_dns_ns_record" "dev_mil" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "dev"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network.name
  ttl                 = var.dns_default_ttl
  tags                = var.tags
  records = [
    "ns1-05.azure-dns.com.",
    "ns2-05.azure-dns.net.",
    "ns3-05.azure-dns.org.",
    "ns4-05.azure-dns.info."
  ]
}

# ------------------------------------------------------------------------------
# This is executed for PROD ONLY and gives Public DNS Delegation to UAT.
# ------------------------------------------------------------------------------
resource "azurerm_dns_ns_record" "uat_mil" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "uat"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network.name
  ttl                 = var.dns_default_ttl
  tags                = var.tags
  records = [
    "ns1-07.azure-dns.com.",
    "ns2-07.azure-dns.net.",
    "ns3-07.azure-dns.org.",
    "ns4-07.azure-dns.info.",
  ]
}

# ------------------------------------------------------------------------------
# Certification Authority Authorization (CAA) record.
# Specify which Certificate Authorities are allowed to issue certificates for
# this domain.
# ------------------------------------------------------------------------------
resource "azurerm_dns_caa_record" "mil" {
  name                = "@"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network.name
  ttl                 = var.dns_default_ttl
  tags                = var.tags

  # This Certification Authority...
  record {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }

  # ...and this one can issue a certificate for this domain...
  record {
    flags = 0
    tag   = "issue"
    value = "digicert.com"
  }

  # ...if someone else tries to issue a certificate, an email is sent to security+caa@pagopa.it.
  record {
    flags = 0
    tag   = "iodef"
    value = "mailto:security+caa@pagopa.it"
  }
}

# ***********************
# *** TEMPORARILY OFF ***
# ***********************
# application gateway records
# api.*.userregistry.pagopa.it
#
#resource "azurerm_dns_a_record" "api" {
#  name                = "api"
#  zone_name           = azurerm_dns_zone.mil.name
#  resource_group_name = azurerm_resource_group.network.name
#  ttl                 = var.dns_default_ttl
#  records             = [azurerm_public_ip.appgw.ip_address]
#
#  tags = var.tags
#}