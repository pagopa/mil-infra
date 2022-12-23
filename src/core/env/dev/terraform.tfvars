# general
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

dns_zone_mil_prefix = "dev.mil"

integr_vnet_cidr = "10.230.12.0/24" # 010.230.012.000 - 010.230.012.255
apim_snet_cidr   = "10.230.12.0/27" # 010.230.012.000 - 010.230.012.031
intern_vnet_cidr = "10.231.0.0/16"  # 010.231.000.000 - 010.231.255.255
dmz_snet_cidr    = "10.231.0.0/24"  # 010.231.000.000 - 010.231.000.255
data_snet_cidr   = "10.231.1.0/24"  # 010.231.001.000 - 010.231.001.255
app_snet_cidr    = "10.231.2.0/23"  # 010.231.002.000 - 010.231.003.255

