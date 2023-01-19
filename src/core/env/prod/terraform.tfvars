# general
env_short      = "p"
env            = "prod"
prefix         = "mil"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "mil"
  Source      = "https://github.com/pagopa/mil-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

dns_zone_mil_prefix = "mil"

#
# App gateway
#

app_gateway = {
  min_capacity = 0
  max_capacity = 2
  waf_enabled  = true
  sku_name     = "WAF_v2"
  sku_tier     = "WAF_v2"
}
