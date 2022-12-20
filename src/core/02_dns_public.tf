resource "azurerm_dns_zone" "mil" {
  name                = "${var.dns_zone_mil_prefix}.${var.dns_external_domain}"
  resource_group_name = azurerm_resource_group.network_rg.name

  tags = var.tags
}

# Prod ONLY record to DEV public DNS delegation
resource "azurerm_dns_ns_record" "dev_mil_ns" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "dev"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network_rg.name
  records = [
    "ns1-05.azure-dns.com.",
    "ns2-05.azure-dns.net.",
    "ns3-05.azure-dns.org.",
    "ns4-05.azure-dns.info."
  ]
  ttl  = var.dns_default_ttl
  tags = var.tags
}

# Prod ONLY record to UAT public DNS delegation
resource "azurerm_dns_ns_record" "uat_mil_ns" {
  count               = var.env_short == "p" ? 1 : 0
  name                = "uat"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network_rg.name
  records = [
    "ns1-07.azure-dns.com.",
    "ns2-07.azure-dns.net.",
    "ns3-07.azure-dns.org.",
    "ns4-07.azure-dns.info.",
  ]
  ttl  = var.dns_default_ttl
  tags = var.tags
}

resource "azurerm_dns_caa_record" "mil" {
  name                = "@"
  zone_name           = azurerm_dns_zone.mil.name
  resource_group_name = azurerm_resource_group.network_rg.name
  ttl                 = var.dns_default_ttl

  record {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }

  record {
    flags = 0
    tag   = "issue"
    value = "digicert.com"
  }

  record {
    flags = 0
    tag   = "iodef"
    value = "mailto:security+caa@pagopa.it"
  }

  tags = var.tags
}